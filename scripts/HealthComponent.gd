extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10.0
var health: float
signal receiveDamage
signal targetDeath
signal playerDeath
signal brokePlayerShield
signal playerHit

func _ready():
	health = MAX_HEALTH
	print("health component health set", health)
	

func damage(attack: Attack):
	var parent = get_parent()
	if parent.is_in_group("Player"):
		handle_player_damage(attack)
	else:
		health -= attack.attack_damage
		print(health)
		if health <= 0:
			targetDeath.emit()
			get_parent().queue_free()

func set_health(current_health: float):
	health = current_health

func handle_player_damage(attack: Attack):
	var final_attack_damage = attack.attack_damage
	if GlobalPlayerInfo.pill:
		final_attack_damage = final_attack_damage * 2
	if GlobalPlayerInfo.shield and !GlobalPlayerInfo.used_shield:
		print("broke shield")
		brokePlayerShield.emit()
		GlobalPlayerInfo.switch_used_shield()
		return
	playerHit.emit()
	health -= final_attack_damage
	print(health)
	receiveDamage.emit()
	if health <= 0:
		if GlobalPlayerInfo.used_revive:
			health = MAX_HEALTH / 2
			GlobalPlayerInfo.switch_used_revive()
			return
		playerDeath.emit()
		GlobalPlayerInfo.reset_on_start_run()
		GlobalPlayerInfo.reset_one_time_items()
