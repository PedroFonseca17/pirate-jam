extends CharacterBody2D
class_name Enemy

@onready var hitbox_component = $HitboxComponent
@onready var hit_animation = $HitAnimation
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer # Timer for delay before attack
@onready var attack_cool_down_timer = $AttackCoolDownTimer # Timer for cooldown between attacks
@onready var health_component = $HealthComponent
@onready var collision_shape_2d = $CollisionShape2D
@onready var enemi_hit = $EnemiHit

@export var attack_damage := 15.0
var knockback_force = 0
var player_inside := false
var is_attacking := false
var isDying = false
signal Enemy_hit

func _ready():
	hitbox_component.Hitbox_hit.connect(on_hit)
	health_component.targetDeath.connect(on_death)

func _physics_process(delta):
	if isDying:
		return
	# Apply movement logic here
	move_and_collide(velocity * delta)
	if abs(velocity.x) > 100 and !is_attacking:
		animated_sprite.flip_h = velocity.x > 0
		animated_sprite.play("side")
	elif velocity.y < -0.1 and !is_attacking:
		animated_sprite.play("back")
	elif velocity.y > 0.1 and !is_attacking:
		animated_sprite.play("front")
	
	velocity = velocity.move_toward(Vector2.ZERO, 100 * delta) # Adjust the drag as needed

func _on_hitbox_component_body_entered(body):
	if isDying:
		return
	if body.is_in_group("Player"):
		player_inside = true
		var overlapping_bodies = $HitboxComponent.get_overlapping_bodies()
		for playerBody in overlapping_bodies:
			if playerBody.is_in_group("Player"):
				start_attack()
				break  # Stop after finding the first player

func _on_hitbox_component_body_exited(body):
	if isDying:
		return
	if body.is_in_group("Player"):
		player_inside = false
		attack_timer.stop()  # Stop the attack delay timer
		attack_cool_down_timer.stop()  # Stop the cooldown timer
		is_attacking = false  # Reset attacking state

func start_attack():
	if isDying:
		return
	if !is_attacking:
		if abs(velocity.x) > 100:
			animated_sprite.flip_h = velocity.x > 0
			animated_sprite.play("side_attack")
		elif velocity.y < -0.1:
			animated_sprite.play("back_attack")
		elif velocity.y > 0.1:
			animated_sprite.play("front_attack")
		is_attacking = true
		attack_timer.start(0.3) # Start the timer to delay the actual attack

func _on_attack_timer_timeout():
	if isDying:
		return
	if player_inside:
		print('player inside')
		var overlapping_bodies = $HitboxComponent.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("Player"):
				attack(body)
				break  # Stop after finding the first player
		# Start cooldown for the next attack
		attack_cool_down_timer.start(1.5)
	else:
		is_attacking = false

func _on_attack_cool_down_timer_timeout():
	if isDying:
		return
	if player_inside:
		start_attack() # Restart attack sequence if player is still inside
	else:
		is_attacking = false

func attack(player: Player):
	if isDying:
		return
	var current_attack = Attack.new()
	current_attack.attack_damage = attack_damage
	current_attack.knockback_force = knockback_force
	current_attack.attack_position = self.global_position

	var hitboxComponent: HitboxComponent = player.get_node("HitboxComponent")
	if hitboxComponent:
		hitboxComponent.damage(current_attack)
	else:
		print("Player does not have a HealthComponent")
	

func on_hit():
	Enemy_hit.emit()
	hit_animation.play("RESET")
	hit_animation.play("hit2")
	enemi_hit.play()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "death":
		queue_free()
		return
	is_attacking = false

func on_death():
	if !isDying:
		isDying = true
		collision_layer = 0 
		collision_shape_2d.disabled = true
		animated_sprite.scale = Vector2(1.2, 1.2)
		animated_sprite.play("death")
