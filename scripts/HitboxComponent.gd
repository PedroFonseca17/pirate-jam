extends Area2D
class_name HitboxComponent

# Define the signal
signal player_entered(player)

@export var health_component: HealthComponent
@export var body: CharacterBody2D

var knockback_velocity: Vector2 = Vector2.ZERO
@export var knockback_friction: float = 50.0 # Adjust this value as needed
signal Hitbox_hit

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		Hitbox_hit.emit()
