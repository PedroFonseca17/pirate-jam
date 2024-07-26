extends CharacterBody2D
class_name RangedEnemy

@onready var hitbox_component = $HitboxComponent
@onready var hit_animation = $HitAnimation
@onready var animated_sprite = $AnimatedSprite2D
@onready var projectile = preload("res://scenes/mageProjectile.tscn")

var attack_damage := 10.0
var knockback_force = 0
var player_inside := false
signal Enemy_hit

var last_faced_direction := Vector2.RIGHT

func _ready():
	hitbox_component.Hitbox_hit.connect(on_hit)
	_start_shooting_coroutine()

func _physics_process(delta):
	# Apply movement logic here
	move_and_collide(velocity * delta)
	if abs(velocity.x) > 100:
		animated_sprite.flip_h = velocity.x < 0
		animated_sprite.play("side")
	elif velocity.y < -0.1:
		animated_sprite.play("back")
	elif velocity.y > 0.1:
		animated_sprite.play("front")
	
	velocity = velocity.move_toward(Vector2.ZERO, 100 * delta) # Adjust the drag as needed

func on_hit():
	Enemy_hit.emit()

func _start_shooting_coroutine():
	# Start the coroutine for shooting projectiles
	call_deferred("_shooting_sequence")

func _shooting_sequence() -> void:
	await get_tree().create_timer(1.0).timeout # Initial delay before starting the shooting sequence
	while true:
		for i in range(20):
			shoot()
			await get_tree().create_timer(0.2).timeout # Wait 0.5 seconds between each shot
		await get_tree().create_timer(3.0).timeout # Wait 3 seconds before shooting again

func shoot():
	var projectile_instance = projectile.instantiate() as MageProjectile
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var direction_to_player = (player.global_position - global_position).normalized()
		last_faced_direction = direction_to_player
		
		var offset = last_faced_direction * 50
		projectile_instance.position = global_position + offset
		projectile_instance.dir = direction_to_player
		projectile_instance.spawnPos = global_position + offset
		projectile_instance.zdex = z_index - 1
		projectile_instance.attack_damage = attack_damage
		projectile_instance.knockback_force = 50
		get_parent().add_child(projectile_instance)
