extends Node2D

@onready var desc = $desc
@onready var shopDisp = $"shop display"
@onready var inventoryDisp = $"inventory slots"
@onready var attackDisp = $"attack slots"
@onready var armorSlot = $"armor slot"
@onready var player:Player = $player
@onready var moneyCount = $"money count"

var merchandise:Array[Item] = []

@export var itemsCommon:Array[PackedScene] = []
@export var itemsUncommon:Array[PackedScene] = []
@export var itemsRare:Array[PackedScene] = []
#@export var itemsLegendary:Array[Item] = []

func _ready():
	randomize()
	initialize()
	player.initialize()
	generate_merchandise()
	update_display()

func initialize():
	#initialize merchendize array
	for i in shopDisp.get_child_count():
		merchandise.push_back(null)
	
	#initialize shop display
	for i in shopDisp.get_child_count():
		var c = shopDisp.get_child(i)
		c.index = i
		c.idx_hover.connect(_on_shop_icon_idx_hover)
		c.idx_pressed.connect(_on_shop_icon_idx_clicked)
	
	#initialize attack display
	for i in attackDisp.get_child_count():
		attackDisp.get_child(i).index = i
	
	#initialize inventory display
	for i in PlayerData.inventorySize:
		var c = inventoryDisp.get_child(i)
		c.index = i
		c.idx_hover.connect(_on_inventory_icon_idx_hover)
		
func generate_merchandise():
	for i in shopDisp.get_child_count():
		shopDisp.get_child(i).index = i
		#if randi_range(1,100) < 95:
		merchandise[i] = itemsCommon.pick_random().instantiate()
		if randi_range(1,100) < 30:
			merchandise[i] = itemsUncommon.pick_random().instantiate()
		if randi_range(1,100) < 15:
			merchandise[i] = itemsRare.pick_random().instantiate()
		#if randi_range(1,100) == 1:
		#	merchandise = itemsLegendary.pick_random()
		merchandise[i].set_price()

func update_display():
	moneyCount.text = str(PlayerData.money)
	#attack icons	
	for i in attackDisp.get_child_count():
		
		var c = attackDisp.get_child(i)
		
		if PlayerData.attacks[i] == null:
			c.disabled = true
		else:
			c.disabled = false
			c.icon = PlayerData.attacks[i].bigIcon
	
	#update armor icon
	armorSlot.texture = PlayerData.armorItem.icon
	
	#update inventory slots
	for i in PlayerData.inventorySize:
		var c = inventoryDisp.get_child(i)
		c.disabled = false
		if PlayerData.inventory[i] == null:
			c.disabled = true
			c.icon = load("res://textures/ui/no item.png")
		else:
			c.icon = PlayerData.inventory[i].get_inventory_icon()
	
	#update shop display
	for i in shopDisp.get_child_count():
		var c = shopDisp.get_child(i)
		
		if merchandise[i] == null:
			c.disabled = true
			c.icon = load("res://textures/ui/no item.png")
		else:
			c.icon = merchandise[i].get_inventory_icon()
			if merchandise[i].price > PlayerData.money:
				c.disabled = true
			else:
				c.disabled = false


func _on_buy_button_pressed():
	shopDisp.visible = true


func _on_sell_button_pressed():
	desc.text = "sell? \n \nthis is a shop mate, i am the one who sells. \n \nif you wanna sell then make your own shop\n\ni'm not going to buy 50 rusty swords from you"


func _on_talk_button_pressed():
	shopDisp.visible = false


func _on_exit_button_pressed():
	SceneChanger.change_scene("res://menus/level_select.tscn")


func _on_armor_slot_mouse_entered():
	desc.text = PlayerData.armorItem.get_description(player)

func _on_attack_icon_idx_hover(idx:int):
	desc.text = PlayerData.attacks[idx].get_description(player.strength, player.mindPower)

func _on_inventory_icon_idx_hover(idx:int):
	if PlayerData.inventory[idx] != null:
		desc.text = PlayerData.inventory[idx].get_description(player)

func _on_shop_icon_idx_hover(idx:int):
	if merchandise[idx] != null:
		desc.text ="price: "+str(merchandise[idx].price)+"\n\n"
		desc.text += merchandise[idx].get_description(player)

func _on_shop_icon_idx_clicked(idx:int):
	if PlayerData.add_to_inventory(merchandise[idx]):
		PlayerData.money = snappedf(PlayerData.money - merchandise[idx].price,0.01)
		merchandise[idx] = null
		update_display()
		
