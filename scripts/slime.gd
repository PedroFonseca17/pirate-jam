extends CharacterBody2D
class_name Slime

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox_component = $HitboxComponent
signal Enemy_hit
@onready var health_component = $HealthComponent
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer


@export var attack_damage := 5.0
var knockback_force = 0
var player_inside := false
var isDying = false

func _ready():
	hitbox_component.Hitbox_hit.connect(on_hit)
	health_component.targetDeath.connect(on_death)

func _physics_process(delta):
	if isDying:
		return
	# Apply movement logic here
	move_and_collide(velocity * delta)
	if abs(velocity.x) > 100:
		animated_sprite.flip_h = velocity.x > 0
		animated_sprite.play("side")
	elif velocity.y < -0.1:
		animated_sprite.play("back")
	elif velocity.y > 0.1:
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
				attack(playerBody)
				$AttackTimer.start()
				break  # Stop after finding the first player

func _on_hitbox_component_body_exited(body):
	if isDying:
		return
	if body.is_in_group("Player"):
		player_inside = false
		$AttackTimer.stop()  # Stop the timer to stop attacking

func _on_attack_timer_timeout():
	if isDying:
		return
	if player_inside:
		var overlapping_bodies = $HitboxComponent.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("Player"):
				attack(body)
				$AttackTimer.start()
				break  # Stop after finding the first player


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
	animation_player.play("RESET")
	animation_player.play("HIT")

func on_death():
	if !isDying:
		collision_shape_2d.disabled = true
		collision_layer = 0 
		isDying = true
		animated_sprite.play("death")

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "death":
		queue_free()
		return
