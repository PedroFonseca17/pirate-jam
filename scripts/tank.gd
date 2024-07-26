extends CharacterBody2D
class_name Enemy

@onready var hitbox_component = $HitboxComponent
@onready var hit_animation = $HitAnimation
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer # Timer for delay before attack
@onready var attack_cool_down_timer = $AttackCoolDownTimer # Timer for cooldown between attacks

var attack_damage := 10.0
var knockback_force = 0
var player_inside := false
var is_attacking := false
signal Enemy_hit

func _ready():
	hitbox_component.Hitbox_hit.connect(on_hit)

func _physics_process(delta):
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
	if body.is_in_group("Player"):
		player_inside = true
		var overlapping_bodies = $HitboxComponent.get_overlapping_bodies()
		for playerBody in overlapping_bodies:
			if playerBody.is_in_group("Player"):
				start_attack()
				break  # Stop after finding the first player

func _on_hitbox_component_body_exited(body):
	if body.is_in_group("Player"):
		player_inside = false
		attack_timer.stop()  # Stop the attack delay timer
		attack_cool_down_timer.stop()  # Stop the cooldown timer
		is_attacking = false  # Reset attacking state

func start_attack():
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
	if player_inside:
		start_attack() # Restart attack sequence if player is still inside
	else:
		is_attacking = false

func attack(player: Player):
	var attack = Attack.new()
	attack.attack_damage = attack_damage
	attack.knockback_force = knockback_force
	attack.attack_position = self.global_position

	var hitboxComponent: HitboxComponent = player.get_node("HitboxComponent")
	if hitboxComponent:
		hitboxComponent.damage(attack)
	else:
		print("Player does not have a HealthComponent")
	

func on_hit():
	Enemy_hit.emit()
	hit_animation.play("hit2")

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
