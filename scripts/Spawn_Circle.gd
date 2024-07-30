extends Node

@onready var sprite_2d = $Sprite2D

var entered_body: bool = false

func _ready():
	pass

func _process(delta):
	if entered_body and Input.is_action_just_pressed("interact"):
		flip()


func flip():
	sprite_2d.texture = load("res://assets/Backgrouds_and_extra/circulo_de_transmutação_aceso.png")


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		entered_body = true
	


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		entered_body = false
