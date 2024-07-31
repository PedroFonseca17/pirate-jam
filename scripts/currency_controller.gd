extends Node2D
class_name CurrencyController

@export var health_component: HealthComponent
@export var VALUE := 10.0
var is_dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	health_component.targetDeath.connect(on_death)

func on_death():
	if is_dead:
		return
	is_dead = true
	var final_value = VALUE
	print("GlobalPlayerInfo.pill", GlobalPlayerInfo.pill)
	if GlobalPlayerInfo.pill:
		final_value = final_value * 2
	print("final value", final_value)
	GlobalPlayerInfo.add_currency(final_value)
