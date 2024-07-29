extends Control

@export var body: CharacterBody2D
@export var boss: CharacterBody2D

@onready var health_bar = $CanvasLayer/healthBar
@onready var boss_bar = $"CanvasLayer/HBoxContainer3/Boss Bar"
@onready var boss_name = $"CanvasLayer/Boss Name"
@onready var revive = $CanvasLayer/HBoxContainer/Revive
@onready var shield = $CanvasLayer/HBoxContainer/Shield
@onready var label = $CanvasLayer/HBoxContainer2/Panel/Label

var tranperant = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	activate_icons()
	health_bar.set_body(body)
	if (boss != null):
		boss_bar.set_body(boss)
	else:
		boss_bar.hide()
		boss_name.hide()
	label.text = str(GlobalPlayerInfo.currency)
	GlobalPlayerInfo.change_currency.connect(on_change_currency)
	GlobalPlayerInfo.shield_used.connect(on_shield_used)
	GlobalPlayerInfo.revive_used.connect(on_revive_used)

func activate_icons():
	if !GlobalPlayerInfo.revive:
		revive.hide()
	else:
		if GlobalPlayerInfo.used_revive:
			on_revive_used()
	if !GlobalPlayerInfo.shield:
		shield.hide()
	else:
		if GlobalPlayerInfo.used_shield:
			on_shield_used()

func on_change_currency():
	label.text = str(GlobalPlayerInfo.currency)

func on_shield_used():
	put_transparent(shield)

func on_revive_used():
	put_transparent(revive)

func put_transparent(panel: Panel):
	var current_color = panel.modulate
	
	current_color.a = tranperant
	
	panel.modulate = current_color
