extends State
class_name BossTeleport

@export var boss: CharacterBody2D
@onready var animated_sprite = boss.get_node("BossSprite") as AnimatedSprite2D
@onready var teleport_area = boss.get_parent().get_node("TeleportArea")
@onready var health_component = boss.get_node("HealthComponent") as HealthComponent
# Handle state variables
var is_teleporting = false


var player : CharacterBody2D # Maybe delete

func Enter():
	animated_sprite.connect("animation_finished", self._on_boss_sprite_animation_finished)
	handleTeleportStart()
	
func Exit():
	# Disconnect the signal
	animated_sprite.disconnect("animation_finished", self._on_boss_sprite_animation_finished)


func Physics_Update(delta: float):
	pass;


func handleTeleportStart():
	animated_sprite.scale = Vector2(2, 2)
	animated_sprite.play("disappear")
	is_teleporting = true
	

func teleport():
	# Get the CollisionShape2D node
	print("teleportei no teleport")
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
		boss.global_position = Vector2(random_x, random_y)
		animated_sprite.play("appear")

func _on_boss_sprite_animation_finished():
	print("ainda no teleport", animated_sprite.animation)
	if animated_sprite.animation == "disappear":
		print(health_component.health)
		if health_component.health < health_component.MAX_HEALTH * 0.2:
			Transitioned.emit(self, 'BossMayhem')
		else:
			teleport()
	elif animated_sprite.animation == "appear":
		is_teleporting = false
		animated_sprite.play("idle")
		animated_sprite.scale = Vector2(0.5, 0.5)
		Transitioned.emit(self, 'BulletStorm')
