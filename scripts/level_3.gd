extends Node2D



func _on_exit_body_entered(body):
	if body.is_in_group("Player"):
		SceneTransition.change_scene("Level_4", self)
