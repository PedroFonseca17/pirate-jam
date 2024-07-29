extends CharacterBody2D
class_name MageProjectile

@export var SPEED = 500

var dir : Vector2
var spawnPos : Vector2
var zdex : int
var attack_damage : int
var knockback_force : int

func _ready():
	global_position = spawnPos
	z_index = zdex
	rotation = dir.angle()

func _physics_process(delta):
	# Move the projectile in the direction it was set to
	var current_velocity = dir * SPEED
	position += current_velocity * delta

func _on_life_timeout():
	queue_free()

func _on_area_2d_area_entered(area: Area2D):
	var enemy = area.get_parent()
	if enemy and enemy.is_in_group("Player"):
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = self.global_position
		area.damage(attack)
		queue_free()

func _on_area_2d_body_entered(_body):
	queue_free()
