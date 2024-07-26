extends Control

@onready var animation_player = $AnimationPlayer
@onready var shop_ui = $shopUI
@onready var appering_text = $ApperingText

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if (GlobalPlayerInfo.intro_scene):
		Dialogic.start("start_Dialog")
	else:
		open_eyes()
		Dialogic.start("back_to_the_beginning")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dialogic_signal(argument: String):
	if (argument == "open_eyes"):
		open_eyes()
	if (argument == "Go to the run"):
		animation_player.play_backwards("open_eyes")
		await animation_player.animation_finished
		appering_text.start_appearingText()
	if (argument == "shop"):
		shop_ui.show()
	if (argument == "begin run"):
		close_eyes()
		SceneTransition.change_scene("Level_2", self)

func open_eyes():
	animation_player.play("open_eyes")
	await animation_player.animation_finished

func close_eyes():
	animation_player.play_backwards("open_eyes")
	await animation_player.animation_finished
	
func reset_focus():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("Back_from_Shop")

func _on_button_pressed():
	GlobalPlayerInfo.view_intro_screen()
	SceneTransition.change_scene("Level_1", self)
