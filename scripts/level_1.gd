extends Node2D

func _on_area_2d_body_entered(body):
	 # Check if the body is the player
	if body.is_in_group("player"):
		SceneTransition.switch_scene_with_clean_up("Level_2", self)
