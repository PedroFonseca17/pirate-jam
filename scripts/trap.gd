extends Node2D
@onready var area_2d = $Area2D
@onready var player = get_tree().get_first_node_in_group("Player") as Player
@onready var animated_sprite = $AnimatedSprite2D
@export var attack_damage = 10
@export var knockback_force = 0
@onready var trap_audio = $trapAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_area_2d_body_entered(body):
	
	if player and body.is_in_group("Player"):
		trap_audio.play()
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = self.global_position
		var hitboxComponent: HitboxComponent = player.get_node("HitboxComponent")
		if hitboxComponent:
			hitboxComponent.damage(attack)
		animated_sprite.play("attack")


func _on_animated_sprite_2d_animation_finished():
	animated_sprite.play("idle")
