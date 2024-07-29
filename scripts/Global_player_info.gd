extends Node

#Switches that conbtrol powerups
var double_dash: bool = false
var shield: bool = false
var revive: bool = false
var pill: bool = false
var more_currency: bool = false
var is_in_textbox_scene = false
var player_health = null
var used_shield = false
var used_revive = false
signal shield_used
signal revive_used

var currency: int = 0
signal change_currency

var intro_scene: bool = true # TODO: put to true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_currency(amount):
	currency += amount
	change_currency.emit()

func remove_currency(amount):
	change_currency.emit()
	currency -= amount

func switch_double_dash():
	if double_dash:
		double_dash = false
	else:
		double_dash = true

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

func switch_more_currency():
	if more_currency:
		more_currency = false
	else:
		more_currency = true

func view_intro_screen():
	intro_scene = false

func switch_is_in_textbox_scene():
	is_in_textbox_scene = !is_in_textbox_scene
	

func switch_pill():
	pill = !pill

func switch_used_shield():
	used_shield = !used_shield
	shield_used.emit()

func switch_used_revive():
	used_revive = !used_revive
	revive_used.emit()

func reset_on_change_level():
	used_shield = false
	
func reset_on_start_run():
	used_shield = false
	used_revive = false
	player_health = null
	
	
func reset_one_time_items():
	pill = false
