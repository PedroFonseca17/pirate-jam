extends Control

var message: String = (
	"dfhgskdfgsdkfgsdfg
	sdfgsdfgsdgsdfgds
	sdgsdgsdfgsdgsdfg
	sdfgsdfgsdfgsdfgsdf
	"
)

@onready var next_leter = $"next leter"
@onready var label = $Label
@onready var button = $Button

var typing_speed = 0.05
var display = ""
var current_char = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	button.hide()

func start_appearingText():
	display = ""
	current_char = 0
	
	next_leter.set_wait_time(typing_speed)
	next_leter.start()


func _on_next_leter_timeout():
	if (current_char < len(message)):
		var next_char = message[current_char]
		display += next_char
		
		label.text = display
		current_char += 1
	else:
		next_leter.stop()
		button.show()
