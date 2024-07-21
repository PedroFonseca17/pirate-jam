extends Area2D
class_name HitboxComponent

# Define the signal
signal player_entered(player)

@export var health_component: HealthComponent
@export var body: CharacterBody2D

var knockback_velocity: Vector2 = Vector2.ZERO
@export var knockback_friction: float = 50.0 # Adjust this value as needed

func damage(attack: Attack):
	print("attack", attack)
	if health_component:
		health_component.damage(attack)
		print(attack.attack_position)
		apply_knockback(attack)

func apply_knockback(attack: Attack):
	print("body", body)
	if body:
		print('applied knockback')
		var knockback_direction = (body.global_position - attack.attack_position).normalized()
		var knockback_velocity = knockback_direction * attack.knockback_force
		body.velocity += knockback_velocity

func _physics_process(delta):
	if body:
		# Apply knockback velocity to the body
		body.velocity += knockback_velocity * delta
		# Reduce the knockback velocity over time using friction
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
