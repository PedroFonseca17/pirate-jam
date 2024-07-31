extends CharacterBody2D
 

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var boss_sprite = $BossSprite
@onready var teleport_area = get_parent().get_node("TeleportArea")
@onready var teleport_timer = $TeleportTimer
@onready var health_component = $HealthComponent
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

signal boss_death
signal boss_room_transition

func _ready():
	health_component.targetDeath.connect(on_death)

func _physics_process(_delta):
	pass

func on_death():
	print("boss death")
	boss_sprite.play("disappear")
	audio_stream_player_2d.playing = true
	boss_death.emit()
	await get_tree().create_timer(7.0).timeout
	queue_free()
	boss_room_transition.emit()
