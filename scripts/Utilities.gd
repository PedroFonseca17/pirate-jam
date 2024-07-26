extends Node

@export var scenes: Array[String] = []
@export var scene_map: Dictionary = {}

var config: ConfigFile

func _ready():
	config = ConfigFile.new()

	for i in range(3):
		config.set_value("Audio", str(i), 0.5)
	
	initialize_scenes()


# Scene manager
func initialize_scenes():
	# Example of loading scenes (replace with actual scene paths)
	scenes.append("res://scenes/main_menu.tscn")
	scenes.append("res://scenes/level_1.tscn")
	scenes.append("res://scenes/level_2.tscn")
	scenes.append("res://scenes/Hub_scene.tscn")
	
	# Map scene names to their indices
	scene_map["MainMenu"] = 0
	scene_map["Level_1"] = 1
	scene_map["Level_2"] = 2
	scene_map["Hub_scene"] = 3



# Scene manager
func switch_scene_with_clean_up(scene_name: StringName, cur_scene: Node):
	var scene = load(scenes[scene_map[scene_name]])
	get_tree().change_scene_to_packed(scene)
