extends State
class_name BulletStorm
@export var boss: CharacterBody2D

@onready var projectile = preload("res://scenes/mageProjectile.tscn")
@onready var animated_sprite = boss.get_node("BossSprite") as AnimatedSprite2D

var player : CharacterBody2D

var is_attacking = false
var last_faced_direction := Vector2.RIGHT
var attack_damage := 10.0
var active_projectiles = 0

func Enter():
	print("was bullet storm called?")
	call_deferred("_shooting_sequence")

func _shooting_sequence() -> void:
	# Handle animation side
	await get_tree().create_timer(1.0).timeout # Initial delay before starting the shooting sequence
	for i in range(30):
		shoot()
		await get_tree().create_timer(0.2).timeout # Wait 0.2 seconds between each shot
	await _wait_for_all_projectiles()

func shoot():
	var projectile_instance = projectile.instantiate() as MageProjectile
	player = get_tree().get_first_node_in_group("Player")
	if player:
		var direction_to_player = (player.global_position - boss.global_position).normalized()
		last_faced_direction = direction_to_player
		
		is_attacking = true
		
		var offset = last_faced_direction * 50
		projectile_instance.position = boss.global_position + offset
		projectile_instance.dir = direction_to_player
		projectile_instance.spawnPos = boss.global_position + offset
		projectile_instance.zdex = boss.z_index - 1
		projectile_instance.attack_damage = attack_damage
		projectile_instance.knockback_force = 50
		
		# Connect projectile destruction signal to track active projectiles
		active_projectiles += 1
		
		get_parent().add_child(projectile_instance)

func _on_projectile_destroyed():
	print("projectile destroyed")
	active_projectiles -= 1

func _wait_for_all_projectiles() -> void:
	print("waiting", active_projectiles)
	Transitioned.emit(self, 'BossTeleport')
