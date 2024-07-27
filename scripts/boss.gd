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
	"""
	if !is_teleporting:
		animated_sprite.scale = Vector2(0.5, 0.5)
		animated_sprite.play("idle")
	"""


"""
func _on_animated_sprite_2d_animation_finished():
	print(animated_sprite.animation)
	if animated_sprite.animation == "disappear":
		teleport()
	elif animated_sprite.animation == "appear":
		is_teleporting = false
		animated_sprite.scale = Vector2(0.5, 0.5)
	"""
"""
func handleTeleportStart():
	animated_sprite.scale = Vector2(2, 2)
	animated_sprite.play("disappear")
	is_teleporting = true
"""
"""
func teleport():
	# Get the CollisionShape2D node
	
	var collision_shape = teleport_area.get_child(0) as CollisionShape2D
	# Check if the collision shape is a RectangleShape2D
	if collision_shape.shape is RectangleShape2D:
		var rect_shape = collision_shape.shape as RectangleShape2D
		var area_position = teleport_area.global_position
		var extents = rect_shape.extents
		
		# Calculate the minimum and maximum bounds based on the rectangle extents and the global position
		var min_x = area_position.x - extents.x
		var max_x = area_position.x + extents.x
		var min_y = area_position.y - extents.y
		var max_y = area_position.y + extents.y
		
		# Generate random coordinates within the defined bounds
		var random_x = randf_range(min_x, max_x)
		var random_y = randf_range(min_y, max_y)
		
		# Set the new position
		global_position = Vector2(random_x, random_y)
		animated_sprite.play("appear")

func _on_teleport_timer_timeout():
	handleTeleportStart()
"""
