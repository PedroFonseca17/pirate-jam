extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10.0
var health: float
signal receiveDamage

func _ready():
	health = MAX_HEALTH
	

func damage(attack: Attack):
	health -=attack.attack_damage
	receiveDamage.emit()
	if health <= 0:
		var parent = get_parent()
		if get_parent().is_in_group("Player"):
			return
		get_parent().queue_free()
