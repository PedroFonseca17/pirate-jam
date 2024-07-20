extends Node2D

@onready var ui_layer: CanvasLayer = $MenuLayer
@onready var settings: Control = $MenuLayer/Panel/Settings

func _ready():
	ui_layer.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		if not ui_layer.visible:
			show_ui_layer()
		else:
			resume_game()

func show_ui_layer():
	pause_game()
	ui_layer.show()
	reset_focus()

func reset_focus():
	$MenuLayer/Panel/PauseMenu/Resume.grab_focus()

func pause_game():
	Engine.time_scale = 0

func resume_game():
	Engine.time_scale = 1
	settings.hide()
	ui_layer.hide()

func _on_resume_pressed():
	resume_game()

func _on_option_pressed():
	settings.show()

func _on_main_menu_pressed():
	Engine.time_scale = 1
	ui_layer.hide()
	Utilities.switch_scene_with_clean_up("MainMenu", self)
