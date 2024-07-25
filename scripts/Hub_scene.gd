extends Node2D

var boolean : bool = true
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if (boolean):
		Dialogic.start("start_Dialog")
	else:
		Dialogic.start("back_to_the_beginning")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dialogic_signal(argument: String):
	if (argument == "open_eyes"):
		animation_player.play("open_eyes")
		await animation_player.animation_finished
	if (argument == "Go to the run"):
		print("hello")
	if (argument == "shop"):
		print("to the shop")
	if (argument == "begin run"):
		print("lets go")
