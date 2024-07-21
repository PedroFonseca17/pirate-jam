# Enemy.gd
extends CharacterBody2D
class_name Enemy

@onready var hitbox_component = $HitboxComponent

var attack_damage := 10.0
var knockback_force = 0
var player_inside := false
signal Enemy_hit

func _ready():
	hitbox_component.Hitbox_hit.connect(on_hit)

func _physics_process(delta):
	# Apply movement logic here
	move_and_slide()
	
	velocity = velocity.move_toward(Vector2.ZERO, 100 * delta) # Adjust the drag as needed

func _on_hitbox_component_body_entered(body):
	if body.is_in_group("Player"):
		print("Player entered the hitbox")
		player_inside = true
		var overlapping_bodies = $HitboxComponent.get_overlapping_bodies()
		for playerBody in overlapping_bodies:
			if playerBody.is_in_group("Player"):
				attack(playerBody)
				$AttackTimer.start()
				break  # Stop after finding the first player

func _on_hitbox_component_body_exited(body):
	if body.is_in_group("Player"):
		player_inside = false
		$AttackTimer.stop()  # Stop the timer to stop attacking

func _on_attack_timer_timeout():
	if player_inside:
		var overlapping_bodies = $HitboxComponent.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("Player"):
				attack(body)
				$AttackTimer.start()
				break  # Stop after finding the first player


func attack(player: Player):
	var attack = Attack.new()
	attack.attack_damage = attack_damage
	attack.knockback_force = knockback_force
	attack.attack_position = self.global_position
	print("Attacked with damage:", attack.attack_damage, "and knockback force:", attack.knockback_force)

	var hitboxComponent: HitboxComponent = player.get_node("HitboxComponent")
	if hitboxComponent:
		hitboxComponent.damage(attack)
		print("Player took damage:", attack.attack_damage)
	else:
		print("Player does not have a HealthComponent")
	

func on_hit():
	Enemy_hit.emit()
