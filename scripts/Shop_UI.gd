extends Control

@export var pre_scene: Node

@onready var currency: Label = $ColorRect/ColorRect/Currency
@onready var dash_button: Button = $"ColorRect/ColorRect/ShopList/Dash/Buy dash"
@onready var shield_button: Button = $"ColorRect/ColorRect/ShopList/Shield/Buy Shield"
@onready var revive_button: Button = $"ColorRect/ColorRect/ShopList/Revive/Buy Revive"
@onready var double_shot_button: Button = $"ColorRect/ColorRect/ShopList/Double Shot/Buy Double Shot"
@onready var more_currency_button: Button = $"ColorRect/ColorRect/ShopList/more_currency/Buy more_currency"

var dash_price: int = 100
var shield_price: int = 200
var revive_price: int = 500
var double_shot_price: int = 250
var more_currency: int = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	currency.text = str(GlobalPlayerInfo.currency)
	button_text()

func button_text():
	check_if_already_bought(GlobalPlayerInfo.dash,dash_price,dash_button)
	check_if_already_bought(GlobalPlayerInfo.shield,shield_price,shield_button)
	check_if_already_bought(GlobalPlayerInfo.revive,revive_price,revive_button)
	check_if_already_bought(GlobalPlayerInfo.double_shot,double_shot_price,double_shot_button)
	check_if_already_bought(GlobalPlayerInfo.more_currency,more_currency,more_currency_button)

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
		handle_button_press(dash_price, "switch_dash",dash_button)

func _on_buy_shield_pressed():
	if (GlobalPlayerInfo.currency >= shield_price):
		handle_button_press(shield_price, "switch_shield",shield_button)

func _on_buy_revive_pressed():
	if (GlobalPlayerInfo.currency >= revive_price):
		handle_button_press(revive_price, "switch_revive",revive_button)

func _on_buy_double_shot_pressed():
	if (GlobalPlayerInfo.currency >= double_shot_price):
		handle_button_press(double_shot_price, "switch_double_shot",double_shot_button)

func _on_buy_more_currency_pressed():
	if (GlobalPlayerInfo.currency >= more_currency):
		handle_button_press(more_currency, "switch_more_currency",more_currency_button)

func handle_button_press(currency: int,switchFn: String ,button: Button):
	GlobalPlayerInfo.call(switchFn)
	GlobalPlayerInfo.remove_currency(currency)
	refresh_currency()
	button.text = "Owned"
	button.disabled = true


func _on_back_pressed():
	hide()
	pre_scene.reset_focus()
