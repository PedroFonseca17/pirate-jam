extends State
class_name BossMayhem

@export var boss: CharacterBody2D
@onready var teleport_area = boss.get_parent().get_node("TeleportArea")
@onready var aoe_left = boss.get_parent().get_node("AOELeft")
@onready var aoe_right = boss.get_parent().get_node("AOERight")
@onready var flame_left = boss.get_parent().get_node("FlameLeft")
@onready var flame_right = boss.get_parent().get_node("FlameRight")

@onready var AOE_left_area = boss.get_parent().get_node("AOELeftArea")
@onready var AOE_right_area = boss.get_parent().get_node("AOERightArea")
@onready var projectile = preload("res://scenes/mageProjectile.tscn")
@onready var AOE_sound_effect_left = boss.get_parent().get_node("ExplosionAudioLeft")
@onready var AOE_sound_effect_right = boss.get_parent().get_node("ExplosionAudioRight")

@onready var player = get_tree().get_first_node_in_group("Player") as Player
@onready var animations = boss.get_node("BossSprite") as AnimatedSprite2D
@export var attack_damage = 10
@export var knockback_force = 0
var boss_is_dead = false

# Variable to keep track of the player
var player_inside_right_aoe = false
var player_inside_left_aoe = false

var is_attacking = false
var last_faced_direction := Vector2.RIGHT
@export var attack_damage_bullet := 10.0

# Probability settings
var probabilities = {
	"first_pattern_aoe": 0.25,
	"second_pattern_aoe": 0.25,
	"third_pattern_aoe": 0.25,
	"fourth_pattern_aoe": 0.25,
}

func Enter():
	boss.boss_death.connect(on_death)
	animations.connect("animation_finished", self._on_animation_finished)
	animations.scale = Vector2(2, 2)
	animations.play("disappear")
	
	
func Exit():
	# Disconnect the signal
	animations.disconnect("animation_finished", self._on_animation_finished)

func _start_aoe() -> void:
	if !get_tree():
		return
	if boss_is_dead:
		return
	handleAttackAnimation("start_attack")
	await run_random_aoe_function()
	handleAttackAnimation("end_attack")
	
	
func _shooting_sequence() -> void:
	if !get_tree():
		return
	if boss_is_dead:
		return
	# Handle animation side
	await get_tree().create_timer(1.0).timeout # Initial delay before starting the shooting sequence
	for i in range(30):
		shoot()
		await get_tree().create_timer(0.2).timeout # Wait 0.2 seconds between each shot
	# await _wait_for_all_projectiles()
	
func shoot():
	if !get_tree():
		return
	if boss_is_dead:
		return
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
		projectile_instance.attack_damage = attack_damage_bullet
		projectile_instance.knockback_force = 50
		
		get_parent().add_child(projectile_instance)

func handleAreaExplosion(side: String):
	if !get_tree():
		return
	if boss_is_dead:
		return
	match side:
		"left":
			if _is_player_inside(AOE_left_area):
				apply_damage()
		"right":
			if _is_player_inside(AOE_right_area):
				apply_damage()

func apply_damage():
	if !get_tree():
		return
	if boss_is_dead:
		return
	var attack = Attack.new()
	attack.attack_damage = attack_damage
	attack.knockback_force = knockback_force
	attack.attack_position = boss.global_position
	var hitboxComponent: HitboxComponent = player.get_node("HitboxComponent")
	if hitboxComponent:
		hitboxComponent.damage(attack)

func _is_player_inside(area: Area2D) -> bool:
	if !get_tree():
		return false
	if boss_is_dead:
		return false
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			return true
	return false

func handleAttackAnimation(animName: String):
	animations.play(animName)

func _on_animation_finished():
	if !get_tree():
		return
	if boss_is_dead:
		return
	var current_animation = animations.animation
	if current_animation == "start_attack":
		handleAttackAnimation("attack_idle")
	elif current_animation == "end_attack":
		animations.play("idle")
		# go to next state
		Transitioned.emit(self, 'BossTeleport')
		pass
	elif current_animation == "appear":
		animations.scale = Vector2(0.5, 0.5)
		call_deferred("_start_aoe")
		call_deferred("_shooting_sequence")
	elif current_animation == "disappear":
		teleportToMiddle()
		
func teleportToMiddle():
	if !get_tree():
		return
	if boss_is_dead:
		return
	# Get the CollisionShape2D node
	var collision_shape = teleport_area.get_child(0) as CollisionShape2D
	# Check if the collision shape is a RectangleShape2D
	if collision_shape.shape is RectangleShape2D:
		var rect_shape = collision_shape.shape as RectangleShape2D
		var area_position = teleport_area.global_position
		var extents = rect_shape.extents
		
		# The global position of the teleport area is already the center
		boss.global_position = area_position
		animations.play("appear")

	
		
""" 
Left warning, right warning, left explosion, right explosion
"""
func first_pattern_aoe():
		# Handle animation side
	await get_tree().create_timer(1.0).timeout # Initial delay before starting the shooting sequence
	aoe_left.visible = true
	await get_tree().create_timer(4).timeout # Wait 5 seconds
	aoe_right.visible = true
	await get_tree().create_timer(1).timeout # Wait 5 seconds
	aoe_left.visible = false
	flame_left.emitting = true
	handleAreaExplosion("left")
	AOE_sound_effect_left.playing = true
	await get_tree().create_timer(1).timeout # Wait 5 seconds
	aoe_right.visible = false
	AOE_sound_effect_right.playing = true
	flame_right.emitting = true
	handleAreaExplosion("right")
	

""" 
Right warning, left warning, right explosion, left explosion
"""
func second_pattern_aoe():
		# Handle animation side
	await get_tree().create_timer(1.0).timeout # Initial delay before starting the shooting sequence
	aoe_right.visible = true
	await get_tree().create_timer(4).timeout # Wait 5 seconds
	aoe_left.visible = true
	await get_tree().create_timer(1).timeout # Wait 5 seconds
	aoe_right.visible = false
	AOE_sound_effect_right.playing = true
	flame_right.emitting = true
	handleAreaExplosion("right")
	await get_tree().create_timer(1).timeout # Wait 5 seconds
	aoe_left.visible = false
	flame_left.emitting = true
	handleAreaExplosion("left")
	AOE_sound_effect_left.playing = true

""" 
Both warnings, left stops warning, right explosion
"""
func third_pattern_aoe():
		# Handle animation side
	await get_tree().create_timer(1.0).timeout # Initial delay before starting the shooting sequence
	aoe_left.visible = true
	aoe_right.visible = true
	await get_tree().create_timer(4).timeout # Wait 5 seconds
	aoe_left.visible = false
	await get_tree().create_timer(2).timeout # Wait 5 seconds
	aoe_right.visible = false
	handleAreaExplosion("right")
	flame_right.emitting = true
	AOE_sound_effect_right.playing = true

""" 
Both warnings, right stops warning, left explosion
"""
func fourth_pattern_aoe():
		# Handle animation side
	await get_tree().create_timer(1.0).timeout # Initial delay before starting the shooting sequence
	aoe_left.visible = true
	aoe_right.visible = true
	await get_tree().create_timer(4).timeout # Wait 5 seconds
	aoe_right.visible = false
	await get_tree().create_timer(2).timeout # Wait 5 seconds
	aoe_left.visible = false
	handleAreaExplosion("left")
	flame_left.emitting = true
	AOE_sound_effect_left.playing = true
	
func run_random_aoe_function():
	if !get_tree():
		return
	if boss_is_dead:
		return
	var random_value = randf()
	var accumulated_probability = 0.0
	
	for function_name in probabilities.keys():
		accumulated_probability += probabilities[function_name]
		if random_value <= accumulated_probability:
			await call(function_name)
			break


func on_death():
	boss_is_dead = true
	flame_left.emitting = false
	flame_right.emitting = false
	aoe_right.visible = false
	aoe_right.visible = false
	AOE_sound_effect_left = false
	
	
	
	
