extends State
class_name BossAOE

@export var boss: CharacterBody2D
@onready var teleport_area = boss.get_parent().get_node("TeleportArea")
@onready var aoe_left = boss.get_parent().get_node("AOELeft")
@onready var aoe_right = boss.get_parent().get_node("AOERight")
@onready var flame_left = boss.get_parent().get_node("FlameLeft")
@onready var flame_right = boss.get_parent().get_node("FlameRight")

@onready var AOE_left_area = boss.get_parent().get_node("AOELeftArea")
@onready var AOE_right_area = boss.get_parent().get_node("AOERightArea")
@onready var AOE_sound_effect_left = boss.get_parent().get_node("ExplosionAudioLeft")
@onready var AOE_sound_effect_right = boss.get_parent().get_node("ExplosionAudioRight")

@onready var player = get_tree().get_first_node_in_group("Player") as Player
@onready var animations = boss.get_node("BossSprite") as AnimatedSprite2D
@export var attack_damage = 10
@export var knockback_force = 0

# Variable to keep track of the player
var player_inside_right_aoe = false
var player_inside_left_aoe = false

# Probability settings
var probabilities = {
	"first_pattern_aoe": 0.25,
	"second_pattern_aoe": 0.25,
	"third_pattern_aoe": 0.25,
	"fourth_pattern_aoe": 0.25,
}

func Enter():
	animations.connect("animation_finished", self._on_animation_finished)
	animations.scale = Vector2(2, 2)
	animations.play("disappear")
	
	
func Exit():
	# Disconnect the signal
	animations.disconnect("animation_finished", self._on_animation_finished)

func _start_aoe() -> void:
	handleAttackAnimation("start_attack")
	if context.data.get("first_aoe_attack", false) == false:
		await first_pattern_aoe()
	else:
		await run_random_aoe_function()
	handleAttackAnimation("end_attack")
	
	context.data["first_aoe_attack"] = true

func handleAreaExplosion(side: String):
	print("handle_area", player_inside_left_aoe, side)
	match side:
		"left":
			if _is_player_inside(AOE_left_area):
				apply_damage()
		"right":
			if _is_player_inside(AOE_right_area):
				apply_damage()

func apply_damage():
	var attack = Attack.new()
	attack.attack_damage = attack_damage
	attack.knockback_force = knockback_force
	attack.attack_position = boss.global_position
	var hitboxComponent: HitboxComponent = player.get_node("HitboxComponent")
	if hitboxComponent:
		hitboxComponent.damage(attack)

func _is_player_inside(area: Area2D) -> bool:
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			return true
	return false

func handleAttackAnimation(animName: String):
	animations.play(animName)

func _on_animation_finished():
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
	elif current_animation == "disappear":
		teleportToMiddle()
		
func teleportToMiddle():
	# Get the CollisionShape2D node
	var collision_shape = teleport_area.get_child(0) as CollisionShape2D
	# Check if the collision shape is a RectangleShape2D
	if collision_shape.shape is RectangleShape2D:
		var rect_shape = collision_shape.shape as RectangleShape2D
		var area_position = teleport_area.global_position
		var extents = rect_shape.extents
		print("extents", extents)
		print("area_position", area_position)
		
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
	var random_value = randf()
	var accumulated_probability = 0.0
	
	for function_name in probabilities.keys():
		accumulated_probability += probabilities[function_name]
		if random_value <= accumulated_probability:
			await call(function_name)
			break
