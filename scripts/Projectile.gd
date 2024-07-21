extends CharacterBody2D
class_name Projectile

@export var SPEED = 1000

var dir : float
var spawnPos : Vector2
var spawnRot : float
var zdex : int
var attack_damage : int
var knockback_force : int

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	print("Projectile spawned at: ", spawnPos, " with direction angle: ", dir)

func _physics_process(delta):
	velocity = Vector2(SPEED, 0).rotated(dir)
	position += velocity * delta

func _on_area_2d_body_entered(area):
	print("area", area)
	if area.is_in_group("Enemies"):
		var enemyHitboxComponent: HitboxComponent = area.get_node("HitboxComponent")
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = self.global_position
		print("HIIIIIT")
		enemyHitboxComponent.damage(attack)
		queue_free()

func _on_life_timeout():
	queue_free()


func _on_area_2d_area_entered(area: Area2D):
	var enemy = area.get_parent()
	if enemy and enemy.is_in_group("Enemies"):
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = self.global_position
		area.damage(attack)
		queue_free()
