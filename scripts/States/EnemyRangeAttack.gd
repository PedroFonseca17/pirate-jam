extends State
class_name EnemyRangeAttack

@export var enemy: CharacterBody2D
@export var move_speed := 150.0
@export var attack_distance := 256 * 3
@export var attack_rate := 1.0 # Attack rate in seconds

var player: CharacterBody2D
var time_since_last_attack := 0.0

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	time_since_last_attack = 0.0

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	var distance_to_player = direction.length()
	
	if distance_to_player > attack_distance + 10:
		# Move towards the player if farther than desired distance + margin
		enemy.velocity = direction.normalized() * move_speed
	elif distance_to_player < attack_distance - 10:
		# Move away from the player if closer than desired distance - margin
		enemy.velocity = -direction.normalized() * move_speed
	else:
		# Stop moving if within the desired distance
		enemy.velocity = Vector2()
		
		# Attack the player if within range
		if time_since_last_attack >= attack_rate:
			_attack()
			time_since_last_attack = 0.0
	
	time_since_last_attack += delta

func _attack():
	# Implement your attack logic here
	print("Attacking player with ranged attack")
	# For example, you could instantiate a projectile and set its direction towards the player
