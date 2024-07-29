extends Node2D
class_name CurrencyController

@export var health_component: HealthComponent
@export var VALUE := 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	health_component.targetDeath.connect(on_death)

func on_death():
	var final_value = VALUE
	if GlobalPlayerInfo.pill:
		final_value = final_value * 2
	GlobalPlayerInfo.add_currency(final_value)