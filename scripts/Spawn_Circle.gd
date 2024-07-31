extends Node

@onready var sprite_2d = $Sprite2D
@onready var boss_spawn = $"Boss spawn"
@onready var fade = $Fade

var entered_body: bool = false
var done: bool = true

func _ready():
	pass

func _process(delta):
	if entered_body and Input.is_action_just_pressed("interact"):
		activate()


func activate():
	if done:
		done = false
		sprite_2d.texture = load("res://assets/Backgrouds_and_extra/circulo_de_transmutação_aceso.png")
		boss_spawn.play()
		await get_tree().create_timer(6).timeout
		SceneTransition.change_scene("Boss_room",self)
	else:
		pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		entered_body = true
		body.show_interact()
	


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		entered_body = false
		body.hide_interact()
