extends CharacterBody2D
class_name Player

enum State {
	IDLE,
	START_MOVE,
	LOOP_MOVE,
	STOP_MOVE
}

var current_state = State.IDLE
var last_direction_change_time = 0.0

@export var speed: int = 750
@onready var animations = $AnimatedSprite2D
@onready var dash_cooldown_timer = $DashCooldownTimer
@onready var projectile = preload("res://scenes/projectile.tscn")
@onready var hitbox_component = $HitboxComponent
@onready var shoot_sound = $shootSound
@onready var hit_sound = $hitSound
@onready var health_component = $HealthComponent
@onready var animation_player = $AnimationPlayer
@onready var shoot_cooldown_timer = $ShootCooldownTimer
@onready var arrow_sprite = $arrow

# Dash properties
const dash_speed = 2250.0
var dash_time_left = 0.5  # Duration of the dash
var last_faced_direction = Vector2.RIGHT
var last_faced_shot = Vector2.RIGHT

var is_dashing = false
var dash_direction = Vector2.ZERO
var dash_count = 0  # Track the number of consecutive dashes

# Attack variables
var attack_damage = 5
var isAttackingAnimation = false

func _ready():
	health_component.playerHit.connect(on_hit)
	dash_cooldown_timer.wait_time = 1.0
	set_state(State.IDLE)
	health_component.playerDeath.connect(_on_player_death)
	health_component.brokePlayerShield.connect(_on_shield_break)
	if GlobalPlayerInfo.player_health:
		health_component.set_health(GlobalPlayerInfo.player_health)

func _physics_process(delta):
	if GlobalPlayerInfo.is_in_textbox_scene:
		if last_faced_direction.x != 0:
			animations.flip_h = last_faced_direction.x > 0
			animations.play("idle_side")
		elif last_faced_direction.y < 0:
			animations.play("idle_up")
		elif last_faced_direction.y > 0:
			animations.play("idle_down")
		return
	
	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false
			velocity = Vector2.ZERO
		else:
			velocity = dash_direction * dash_speed
			move_and_slide()
			return
	
	# Maintain the value as true while shooting is pressed
	if Input.is_action_pressed("shoot"):
		isAttackingAnimation = true
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		last_faced_direction = direction.normalized()
	
	if Input.is_action_just_pressed("dash") and dash_count < 2:
		start_dash(direction)
		
	if Input.is_action_pressed("shoot") and shoot_cooldown_timer.is_stopped():
		shoot()
	
	velocity += (hitbox_component.knockback_velocity * delta)
	handleMovementInput()
	move_and_slide()
	updateAnimation()
	update_arrow_direction()
	GlobalPlayerInfo.player_health = health_component.health

func handleMovementInput():
	var moveDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = moveDirection * speed

	if moveDirection != Vector2.ZERO:
		var now = Time.get_ticks_msec()
		if current_state == State.IDLE or current_state == State.STOP_MOVE:
			set_state(State.START_MOVE)
		last_direction_change_time = now
	else:
		if current_state == State.LOOP_MOVE or current_state == State.START_MOVE:
			set_state(State.STOP_MOVE)

func start_dash(direction):
	print(dash_count)
	if dash_count >= 2 and not dash_cooldown_timer.is_stopped():
		return
		
	if dash_count == 1 and !GlobalPlayerInfo.double_dash:
		return

	if direction != Vector2.ZERO:
		dash_direction = direction.normalized()
	else:
		dash_direction = velocity.normalized()
	
	is_dashing = true
	dash_time_left = 0.2
	dash_count += 1  # Increment the dash count

	if dash_count == 1:
		print("started dash_cooldown_timer")
		dash_cooldown_timer.start()  # Start cooldown only after the first dash

func shoot():
	shoot_sound.play()
	var projectile_instance = projectile.instantiate() as Projectile
	var offset = Vector2(0, 0)  # Default offset

	# Check for arrow keys and adjust the direction and offset accordingly
	if Input.is_action_pressed("ui_left"):
		last_faced_shot = Vector2(-1, 0)
		offset = Vector2(-50, 0)
		animations.play("attack_left")
	elif Input.is_action_pressed("ui_right"):
		last_faced_shot = Vector2(1, 0)
		offset = Vector2(50, 0)
		animations.flip_h = false
		animations.play("attack_right")
	elif Input.is_action_pressed("ui_up"):
		last_faced_shot = Vector2(0, -1)
		offset = Vector2(0, -50)
		animations.play("attack_back")
	elif Input.is_action_pressed("ui_down"):
		last_faced_shot = Vector2(0, 1)
		offset = Vector2(0, 50)
		animations.play("attack_front")
	else:
		last_faced_shot = last_faced_direction
		if last_faced_direction.x < 0:
			animations.play("attack_left")
			last_faced_shot = last_faced_direction
		elif last_faced_direction.x > 0:
			animations.flip_h = false
			animations.play("attack_right")
		elif last_faced_direction.y < 0:
			animations.play("attack_back")
		elif last_faced_direction.y > 0:
			animations.play("attack_front")

	isAttackingAnimation = true

	# Ensure the projectile direction is set based on the last_faced_shot
	projectile_instance.dir = last_faced_shot.angle()
	projectile_instance.spawnPos = global_position + offset
	projectile_instance.spawnRot = last_faced_shot.angle()
	projectile_instance.zdex = z_index - 1
	projectile_instance.attack_damage = attack_damage
	projectile_instance.knockback_force = 50
	get_parent().add_child(projectile_instance)
	shoot_cooldown_timer.start(0.3)  # Start the cooldown timer for shooting

func update_arrow_direction():
	var player_size = Vector2(256, 256)
	var offset = Vector2(player_size.x / 2, 0)

	if Input.is_action_pressed("ui_left"):
		arrow_sprite.modulate.a = 1
		arrow_sprite.rotation_degrees = 180
		arrow_sprite.flip_v = true
		offset = Vector2(-player_size.x / 2, 0)
	elif Input.is_action_pressed("ui_right"):
		arrow_sprite.modulate.a = 1
		arrow_sprite.rotation_degrees = 0
		arrow_sprite.flip_h = false
		offset = Vector2(player_size.x / 2, 0)
	elif Input.is_action_pressed("ui_up"):
		arrow_sprite.modulate.a = 1
		arrow_sprite.rotation_degrees = -90
		arrow_sprite.flip_h = false
		offset = Vector2(0, -player_size.y / 1.5)
	elif Input.is_action_pressed("ui_down"):
		arrow_sprite.modulate.a = 1
		arrow_sprite.rotation_degrees = 90
		arrow_sprite.flip_h = false
		offset = Vector2(0, player_size.y / 1.5)
	else:
		arrow_sprite.modulate.a = 0

	arrow_sprite.position = offset

func _on_shoot_cooldown_timer_timeout():
	pass

func updateAnimation():
	match current_state:
		State.IDLE:
			if last_faced_direction.x != 0 and !isAttackingAnimation:
				animations.flip_h = last_faced_direction.x > 0
				animations.play("idle_side")
			elif last_faced_direction.y < 0 and !isAttackingAnimation:
				animations.play("idle_up")
			elif last_faced_direction.y > 0 and !isAttackingAnimation:
				animations.play("idle_down")
		State.START_MOVE:
			if velocity.x != 0 and !isAttackingAnimation:
				animations.flip_h = velocity.x > 0
				animations.play("start_move")
			elif velocity.y < 0 and !isAttackingAnimation:
				animations.play("loop_move_up")
			elif velocity.y > 0 and !isAttackingAnimation:
				animations.play("loop_move_down")
		State.LOOP_MOVE:
			if velocity.x != 0 and !isAttackingAnimation:
				animations.flip_h = velocity.x > 0
				animations.play("loop_move")
			elif velocity.y < 0 and !isAttackingAnimation:
				animations.play("loop_move_up")
			elif velocity.y > 0 and !isAttackingAnimation:
				animations.play("loop_move_down")
		State.STOP_MOVE:
			if last_faced_direction.x != 0 and !isAttackingAnimation:
				animations.flip_h = last_faced_direction.x > 0
				animations.play("stop_move")
			elif last_faced_direction.y < 0 and !isAttackingAnimation:
				animations.play("idle_up")
			elif last_faced_direction.y > 0 and !isAttackingAnimation:
				animations.play("idle_down")

func set_state(new_state):
	if current_state == new_state:
		return

	current_state = new_state
	updateAnimation()

func _on_animated_sprite_2d_animation_finished():
	if current_state == State.START_MOVE:
		set_state(State.LOOP_MOVE)
	elif current_state == State.STOP_MOVE:
		set_state(State.IDLE)
		
	isAttackingAnimation = false

func on_hit():
	animation_player.play("RESET")
	animation_player.play("HIT")
	
func _on_player_death():
	SceneTransition.change_scene("Hub_scene", self)


func _on_dash_cooldown_timer_timeout():
	dash_count = 0  # Reset dash count after dash ends

func _on_shield_break():
	animation_player.play("RESET")
	animation_player.play("shield_break")
	pass;
