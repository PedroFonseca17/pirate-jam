extends Control

@export var pre_scene: Node

func _ready():
	hide()

func _on_back_pressed():
	hide()
	pre_scene.reset_focus()
