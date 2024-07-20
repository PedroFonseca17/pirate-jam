extends CharacterBody2D
class_name Player

@export var speed: int = 750
@onready var animations = $AnimationPlayer
@onready var dash_cooldown_timer = $DashCooldownTimer
@onready var projectile = preload("res://scenes/projectile.tscn")
## This variables define the dash properties
const dash_speed = 1250.0
var dash_time_left = 0.5  # Duration of the dash
var last_faced_direction = Vector2.RIGHT

var is_dashing = false
var dash_direction = Vector2.ZERO

## Atack Variables
var attack_damage = 20

func _ready():
	# Ensure dash cooldown timer is set to 1 seconds
	dash_cooldown_timer.wait_time = 1.0

func _physics_process(delta):
	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false
			velocity = Vector2.ZERO
		else:
			velocity = dash_direction * dash_speed
			move_and_slide()
			return
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		last_faced_direction = direction.normalized()
	
	# Handle dash input
	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown_timer.is_stopped():
		start_dash(direction)
		
	# Handle shoot input
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	handleMovementInput()
	move_and_slide()
#	updateAnimation()

func handleMovementInput():
	var moveDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = moveDirection * speed

func start_dash(direction):
	if is_dashing:
		return

	if direction != Vector2.ZERO:
		dash_direction = direction.normalized()
	else:
		dash_direction = velocity.normalized()
	
	is_dashing = true
	dash_time_left = 0.2  # Reset dash time left
	dash_cooldown_timer.start()  # Start the cooldown timer

func shoot():
	var projectile_instance = projectile.instantiate() as Projectile
	var offset = last_faced_direction * 50  # Adjust the offset value as needed
	projectile_instance.dir = last_faced_direction.angle()
	projectile_instance.spawnPos = global_position + offset
	projectile_instance.spawnRot = last_faced_direction.angle()
	projectile_instance.zdex = z_index - 1
	projectile_instance.attack_damage = attack_damage
	print("Shooting direction angle: ", last_faced_direction.angle())
	get_parent().add_child(projectile_instance)

#	
#func updateAnimation():
#	if velocity.length() == 0:
#		if animations.is_playing():
#			animations.stop()
#	else:
#		var direction = "Down"
#		if velocity.x < 0: direction = "Left"
#		elif velocity.x > 0: direction = "Right"
#		elif velocity.y < 0: direction = "Up"

#		animations.play("walk" + direction)
