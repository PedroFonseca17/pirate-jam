extends Control

@onready var option_menu: Control = $"../Settings"

func _ready():
	$VBoxContainer/Start.grab_focus()

func reset_focus():
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed():
	Utilities.switch_scene_with_clean_up("Hub_scene", self)

func _on_option_pressed():
	option_menu.show()

func _on_exit_pressed():
	get_tree().quit()
