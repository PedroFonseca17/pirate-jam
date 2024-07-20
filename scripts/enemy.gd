# Enemy.gd
extends CharacterBody2D

var attack_damage := 10.0
var knockback_force := 100.0
var player_inside := false

func _on_hitbox_component_body_entered(body):
	print('he inside')
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
		print("Player exited the hitbox")
		player_inside = false
		$AttackTimer.stop()  # Stop the timer to stop attacking

func _on_attack_timer_timeout():
	if player_inside:
		print("Timer triggered, attacking player")
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
	print("Attacked with damage:", attack.attack_damage, "and knockback force:", attack.knockback_force)

	var health_component: HealthComponent = player.get_node("HealthComponent")
	if health_component:
		health_component.damage(attack)
		print("Player took damage:", attack.attack_damage)
	else:
		print("Player does not have a HealthComponent")
	
