extends Node

@export var body: CharacterBody2D

@onready var progress_bar = $ProgressBar

var healthComponent: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	if body != null:
		healthComponent = body.get_node("HealthComponent")
		progress_bar.max_value = healthComponent.MAX_HEALTH
		progress_bar.value = healthComponent.health
		healthComponent.receiveDamage.connect(on_receive_damage)

func set_body(recieved_body: CharacterBody2D):
	body = recieved_body
	_ready()

func on_receive_damage():
	progress_bar.value = healthComponent.health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
