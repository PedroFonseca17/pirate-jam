extends Node

@export var scenes: Array[PackedScene] = []
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
	scenes.append(load("res://scenes/main_menu.tscn"))
	scenes.append(load("res://scenes/level_1.tscn"))
	scenes.append(load("res://scenes/level_2.tscn"))
	
	# Map scene names to their indices
	scene_map["MainMenu"] = 0
	scene_map["Level_1"] = 1
	scene_map["Level_2"] = 2



# Scene manager
func switch_scene(scene_name: StringName, cur_scene: Node):
	var scene = scenes[scene_map[scene_name]].instantiate()
	get_tree().root.add_child(scene)
	cur_scene.queue_free()
