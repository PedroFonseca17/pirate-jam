extends Control


func _ready():
	$VBoxContainer/Start.grab_focus()

func reset_focus():
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed():
	Utilities.switch_scene("Level_1", self)

func _on_exit_pressed():
	get_tree().quit()
