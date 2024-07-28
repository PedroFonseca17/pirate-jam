extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D
@onready var teleport_area = get_parent().get_node("TeleportArea")
@onready var teleport_timer = $TeleportTimer


func _physics_process(delta):
	pass
