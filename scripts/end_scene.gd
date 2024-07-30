extends Node

func _on_button_pressed():
	SceneTransition.change_scene("Hub_scene", self)
