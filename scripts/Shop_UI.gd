extends Control

@export var pre_scene: Node

@onready var currency: Label = $ColorRect/ColorRect/Currency
@onready var dash_button: Button = $"ColorRect/ColorRect/ShopList/Dash/Buy dash"
@onready var shield_button: Button = $"ColorRect/ColorRect/ShopList/Shield/Buy Shield"
@onready var revive_button: Button = $"ColorRect/ColorRect/ShopList/Revive/Buy Revive"
@onready var more_currency_button: Button = $"ColorRect/ColorRect/ShopList/more_currency/Buy more_currency"
@onready var buy_health = $"ColorRect/ColorRect/ShopList/Health/Buy Health"

var dash_price: int = 300
var shield_price: int = 250
var revive_price: int = 600
var more_currency: int = 100
var health_boost_price: int = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	currency.text = str(GlobalPlayerInfo.currency)
	button_text()

func button_text():
	check_if_already_bought(GlobalPlayerInfo.double_dash,dash_price,dash_button)
	check_if_already_bought(GlobalPlayerInfo.shield,shield_price,shield_button)
	check_if_already_bought(GlobalPlayerInfo.revive,revive_price,revive_button)
	check_if_already_bought(GlobalPlayerInfo.pill,more_currency,more_currency_button)
	buy_health.text = str(health_boost_price)

func check_if_already_bought(item: bool, itemValue: int, button: Button):
	if (item):
		button.text = "Owned"
		button.disabled = true
	else:
		button.text = str(itemValue)
	

func refresh_currency():
	currency.text = str(GlobalPlayerInfo.currency)

func _on_buy_dash_pressed():
	if (GlobalPlayerInfo.currency >= dash_price):
		handle_button_press(dash_price, "switch_double_dash",dash_button)

func _on_buy_shield_pressed():
	if (GlobalPlayerInfo.currency >= shield_price):
		handle_button_press(shield_price, "switch_shield",shield_button)

func _on_buy_revive_pressed():
	if (GlobalPlayerInfo.currency >= revive_price):
		handle_button_press(revive_price, "switch_revive",revive_button)


func _on_buy_more_currency_pressed():
	if (GlobalPlayerInfo.currency >= more_currency):
		handle_button_press(more_currency, "switch_pill",more_currency_button)

func handle_button_press(price: int,switchFn: String ,button: Button):
	GlobalPlayerInfo.call(switchFn)
	GlobalPlayerInfo.remove_currency(price)
	refresh_currency()
	button.text = "Owned"
	button.disabled = true


func _on_back_pressed():
	hide()
	pre_scene.reset_focus()


func _on_buy_health_pressed():
	if (GlobalPlayerInfo.currency >= health_boost_price):
		print("bought")
		GlobalPlayerInfo.add_player_health()
		GlobalPlayerInfo.remove_currency(health_boost_price)
		refresh_currency()
