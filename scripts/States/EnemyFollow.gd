extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 150.0
var player: CharacterBody2D
@export var navigation_agent_2d: NavigationAgent2D
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	if !navigation_agent_2d:
		return
	call_deferred("seeker_setup")
	pass # Replace with function body.

func seeker_setup():
	if !navigation_agent_2d:
		return
	await get_tree().physics_frame
	if player:
		navigation_agent_2d.target_position = player.global_position
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta):
	if !navigation_agent_2d:
		return
	if is_instance_valid(player):
		navigation_agent_2d.target_position = player.global_position
	if navigation_agent_2d.is_navigation_finished():
		return
		
	var current_agent_position = enemy.global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * move_speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	enemy.move_and_slide()
	pass


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	enemy.velocity = safe_velocity
	pass # Replace with function body.
