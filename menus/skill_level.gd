extends Node2D

@onready var displays = $displays
@onready var priceDisps = $prices
@onready var buttons = $buttons
@onready var playerMoneyDisp = $money
@onready var noMoneyDisp = $"no money"

var basePrice:Array[int] = [100,100,100,100,100]
var price:Array[int] = [0,0,0,0,0]

func _ready():
	update()

func update():
	playerMoneyDisp.text = str(PlayerData.money)
	
	for i in 5:
		price[i] = int(Globals.priceModifiers[i]*log(basePrice[i]*Globals.priceModifiers[i]))*10
		priceDisps.get_child(i).text = str(price[i])
	
	displays.get_child(0).text = "current: "+str(PlayerData.strength)
	displays.get_child(1).text = "current: "+str(PlayerData.mindPower)
	displays.get_child(2).text = "current: "+str(PlayerData.maxHealth)
	displays.get_child(3).text = "current: "+str(PlayerData.maxSanity)
	displays.get_child(4).text = "current: "+str(PlayerData.maxMana)
		

func _on_str_button_pressed():
	if price[0] <= PlayerData.money:
		noMoneyDisp.visible = false
		PlayerData.strength += 20
		PlayerData.money -= price[0]
		PlayerData.money = snappedf(PlayerData.money,0.01)
		Globals.priceModifiers[0] += 1
	else:
		noMoneyDisp.visible = true
	update()

func _on_mag_button_pressed():
	if price[1] <= PlayerData.money:
		noMoneyDisp.visible = false
		PlayerData.mindPower += 20
		PlayerData.money -= price[1]
		Globals.priceModifiers[1] += 1
	else:
		noMoneyDisp.visible = true
	update()


func _on_hp_button_pressed():
	if price[2] <= PlayerData.money:
		noMoneyDisp.visible = false
		PlayerData.maxHealth += 50
		PlayerData.money -= price[2]
		Globals.priceModifiers[2] += 1
	else:
		noMoneyDisp.visible = true
	update()


func _on_san_button_pressed():
	if price[3] <= PlayerData.money:
		noMoneyDisp.visible = false
		PlayerData.maxSanity += 50
		PlayerData.money -= price[3]
		Globals.priceModifiers[3] += 1
	else:
		noMoneyDisp.visible = true
	update()


func _on_mana_button_pressed():
	if price[4] <= PlayerData.money:
		noMoneyDisp.visible = false
		PlayerData.maxMana += 50
		PlayerData.money -= price[4]
		Globals.priceModifiers[4] += 1
	else:
		noMoneyDisp.visible = true
	update()

func _on_return_button_pressed():
	SceneChanger.change_scene("res://menus/level_select.tscn")
