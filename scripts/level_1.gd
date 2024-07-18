extends Node2D


func _on_area_2d_body_entered(body):
	 # Check if the body is the player
	if body.is_in_group("player"):
		SceneTransition.change_scene("res://scenes/level_2.tscn")
