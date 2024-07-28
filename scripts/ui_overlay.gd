extends Control

@export var body: CharacterBody2D

@onready var health_bar = $CanvasLayer/healthBar
@onready var double_dash = $"CanvasLayer/HBoxContainer/Double Dash"
@onready var double_shoot = $"CanvasLayer/HBoxContainer/Double Shoot"
@onready var double_revive = $"CanvasLayer/HBoxContainer/Double Revive"
@onready var double_shield = $"CanvasLayer/HBoxContainer/Double Shield"
@onready var label = $CanvasLayer/HBoxContainer2/Panel/Label
var doubleShotCooldown: Timer
var doubleDashCooldown: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	activate_icons()
	health_bar.set_body(body)
	label.text = str(GlobalPlayerInfo.currency)
	GlobalPlayerInfo.change_currency.connect(on_change_currency)

func activate_icons():
	if !GlobalPlayerInfo.double_shot:
		double_shoot.hide()
	if !GlobalPlayerInfo.double_dash:
		double_dash.hide()
	if !GlobalPlayerInfo.revive:
		double_revive.hide()
	if !GlobalPlayerInfo.shield:
		double_shield.hide()

func on_change_currency():
	label.text = str(GlobalPlayerInfo.currency)
