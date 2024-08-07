extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10.0
var health: float
signal receiveDamage
signal targetDeath
signal playerDeath
signal brokePlayerShield
signal playerHit
var is_player_death = false

func _ready():
	if get_parent().is_in_group("Player"):
		health = GlobalPlayerInfo.player_max_health
		return
	health = MAX_HEALTH
	
func change_max_health(amount):
	MAX_HEALTH = amount
	health = MAX_HEALTH

func damage(attack: Attack):
	var parent = get_parent()
	if parent.is_in_group("Player"):
		handle_player_damage(attack)
	else:
		health -= attack.attack_damage
		if (parent.is_in_group("Boss")):
			receiveDamage.emit()
		print(health)
		if health <= 0:
			targetDeath.emit()

func set_health(current_health: float):
	health = current_health

func handle_player_damage(attack: Attack):
	if GlobalPlayerInfo.is_player_invincible:
		return
	print("damage tacken",attack.attack_damage )
	var final_attack_damage = attack.attack_damage
	if GlobalPlayerInfo.pill:
		final_attack_damage = final_attack_damage * 2
	print("final_attack_damage", final_attack_damage)
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
		if is_player_death:
			return
		if GlobalPlayerInfo.revive and !GlobalPlayerInfo.used_revive:
			health = MAX_HEALTH / 2
			receiveDamage.emit()
			GlobalPlayerInfo.switch_used_revive()
			return
		is_player_death = true
		playerDeath.emit()
		GlobalPlayerInfo.reset_on_start_run()
		GlobalPlayerInfo.reset_one_time_items()
