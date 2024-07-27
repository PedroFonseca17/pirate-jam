extends Control

@export var body: CharacterBody2D

@onready var health_bar = $CanvasLayer/healthBar
@onready var double_dash = $"CanvasLayer/HBoxContainer/Double Dash"
@onready var double_shoot = $"CanvasLayer/HBoxContainer/Double Shoot"
@onready var label = $CanvasLayer/Panel/Label

var doubleShotCooldown: Timer
var doubleDashCooldown: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	if !GlobalPlayerInfo.double_shot:
		double_shoot.hide()
	if !GlobalPlayerInfo.dash:
		double_dash.hide()
	health_bar.set_body(body)
	label.text = str(GlobalPlayerInfo.currency)
	GlobalPlayerInfo.change_currency.connect(on_change_currency)

func on_change_currency():
	label.text = str(GlobalPlayerInfo.currency)
