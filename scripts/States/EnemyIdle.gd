extends State
class_name EnemyIdle

@export var enemy: Enemy
@export var move_speed := 140.0

var player : CharacterBody2D

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.Enemy_hit.connect(on_enemy_hit)
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
		
	else:
		randomize_wander()
		
func Physics_Update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
		
	var direction = player.global_position - enemy.global_position
	if direction.length() < 250:
		Transitioned.emit(self, 'Follow')

func on_enemy_hit():
	Transitioned.emit(self, 'Follow')