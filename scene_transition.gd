extends CanvasLayer

func change_scene(target: StringName, cur_scene: Node) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	Utilities.switch_scene_with_clean_up(target,cur_scene)
	$AnimationPlayer.play_backwards("dissolve")
