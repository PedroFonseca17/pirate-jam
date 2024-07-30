extends Node2D
@onready var bridge_scene_trigger = $BridgeSceneTrigger
@onready var bridge = $Bridge
var has_bridge_scene_played = false
@onready var exit_trigger = $ExitTrigger
@onready var ambient_music = $player/AmbientMusic

func _ready():
	ambient_music.play()
	bridge.texture = load("res://assets/bridge-broken.png")
	Dialogic.signal_event.connect(_handle_dialogic_signals)

func _handle_dialogic_signals(argument: String):
	if (argument == "restore_bridge"):
		bridge.texture = load("res://assets/bridge-complete.png")
	if (argument == "restore_bridge_finished"):
		GlobalPlayerInfo.switch_is_in_textbox_scene()

func _on_bridge_scene_trigger_body_entered(body):
	if body.is_in_group("Player") and !has_bridge_scene_played:
		has_bridge_scene_played = true
		GlobalPlayerInfo.switch_is_in_textbox_scene()
		Dialogic.start("Bridge_dialog")
	pass



func _on_exit_trigger_body_entered(body):
	if body.is_in_group("Player"):
		SceneTransition.change_scene("Level_2", self)
