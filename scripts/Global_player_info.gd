extends Node

#Switches that conbtrol powerups
var dash: bool = false
var shield: bool = false
var revive: bool = false
var double_shot: bool = false
var more_currency: bool = false

var currency: int = 2000
signal change_currency

var intro_scene: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_currency(amount):
	change_currency.emit()
	currency += amount

func remove_currency(amount):
	change_currency.emit()
	currency -= amount

func switch_dash():
	if dash:
		dash = false
	else:
		dash = true

func switch_shield():
	if shield:
		shield = false
	else:
		shield = true

func switch_revive():
	if revive:
		revive = false
	else:
		revive = true

func switch_double_shot():
	if double_shot:
		double_shot = false
	else:
		double_shot = true

func switch_more_currency():
	if more_currency:
		more_currency = false
	else:
		more_currency = true

func view_intro_screen():
	intro_scene = false

	
