extends Control

@onready var currency: Label = $ColorRect/ColorRect/Currency
@onready var dash_button: Button = $"ColorRect/ColorRect/ShopList/Dash/Buy dash"
@onready var shield_button: Button = $"ColorRect/ColorRect/ShopList/Shield/Buy Shield"
@onready var revive_button: Button = $"ColorRect/ColorRect/ShopList/Revive/Buy Revive"
@onready var double_shot_button: Button = $"ColorRect/ColorRect/ShopList/Double Shot/Buy Double Shot"

var dash_price: int = 100
var shield_price: int = 200
var revive_price: int = 500
var double_shot_price: int = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	currency.text = str(GlobalPlayerInfo.currency)
	dash_button.text = str(dash_price)
	shield_button.text = str(shield_price)
	revive_button.text = str(revive_price)
	double_shot_button.text = str(double_shot_price)

func refresh_currency():
	currency.text = str(GlobalPlayerInfo.currency)

func _on_buy_dash_pressed():
	if (GlobalPlayerInfo.currency >= dash_price):
		GlobalPlayerInfo.switch_dash()
		GlobalPlayerInfo.remove_currency(dash_price)
		refresh_currency()
		dash_button.disabled = true


func _on_buy_shield_pressed():
	if (GlobalPlayerInfo.currency >= shield_price):
		GlobalPlayerInfo.switch_shield()
		GlobalPlayerInfo.remove_currency(shield_price)
		refresh_currency()
		shield_button.disabled = true


func _on_buy_revive_pressed():
	if (GlobalPlayerInfo.currency >= revive_price):
		GlobalPlayerInfo.switch_dash()
		GlobalPlayerInfo.remove_currency(revive_price)
		refresh_currency()
		revive_button.disabled = true


func _on_buy_double_shot_pressed():
	if (GlobalPlayerInfo.currency >= double_shot_price):
		GlobalPlayerInfo.switch_dash()
		GlobalPlayerInfo.remove_currency(double_shot_price)
		refresh_currency()
		double_shot_button.disabled = true
