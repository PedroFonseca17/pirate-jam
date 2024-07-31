extends State

@export var boss: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	Transitioned.emit(self, 'BulletStorm')
