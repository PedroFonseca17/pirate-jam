extends Area2D
class_name HitboxComponent

# Define the signal
signal player_entered(player)

@export var health_component: HealthComponent

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
