extends Node2D
@onready var boss = $Boss
@onready var background_music = $BackgroundMusic


# Called when the node enters the scene tree for the first time.
func _ready():
	boss.boss_room_transition.connect(_on_boss_death)


func _on_boss_death():
	background_music.playing = false
	SceneTransition.change_scene("End_scene", self)
