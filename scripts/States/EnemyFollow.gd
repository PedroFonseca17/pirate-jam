extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 200.0
var player: CharacterBody2D

	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	print("enemy directio follow", direction)
	# This is the space between the enemy and the player
	if direction.length() > 10:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
	
	# Necessary distance between them to go idle
	# if direction.length() > 750:
	#	Transitioned.emit(self, "idle")