extends Control

@onready var attackButtons = $attacks
@onready var desc = $desc
@onready var inventoryDisp = $inventory
@onready var useItemWindow = $"use item window"
@onready var changeAttackWindow = $"change attack window"
@onready var lootWindow  = $"loot window"
@onready var nextLevelButton = $"next level button"
@onready var moneyCount = $"money count"

var player:Player
var lootItem:Item

signal changeTurn
signal nextLevelPressed
signal attackChosen(index:int)
signal itemUsed(index:int)

func _ready():
	#connct inventory buttons
	var i = 0
	for butt in inventoryDisp.get_children():
		butt.index = i
		i += 1
		butt.idx_hover.connect(_on_inv_idx_hover)
		butt.idx_pressed.connect(_on_inv_idx_pressed)

func disable_all():
	for i in attackButtons.get_children():
		i.disabled = true
	for i in inventoryDisp.get_children():
		i.disabled = true

func reload_ui():
	moneyCount.text = str(PlayerData.money)
	reload_attacks()
	reload_inventory()

func reload_attacks():
	var i = 0
	for att in PlayerData.attacks:
		var butt = attackButtons.get_child(i)
		
		#the attack doesn't exist
		if att == null:
			butt.disabled = true
			butt.icon = load("res://textures/ui/no item.png")
		#the attack does exist
		else:
			butt.icon = att.bigIcon
			if att.healthCost > player.health or att.manaCost > player.mana or att.emotionalCost > player.sanity:
				butt.disabled = true
			else:
				butt.disabled = false
		i+=1

func reload_inventory():
	var i = 0
	for inv in PlayerData.inventory:
		var butt = inventoryDisp.get_child(i)
		
		#the item doesn't exist
		if inv == null:
			butt.disabled = true
			butt.icon = load("res://textures/ui/no item.png")
			
		#the item does exist
		
		else:
			butt.icon = inv.icon
			if inv.itemType == inv.itemTypes.ATTACK:
				butt.icon = inv.get_inventory_icon()
			else:
				butt.icon = inv.icon
			
			'''if inv.itemType == inv.itemTypes.CONSUMABLE:
				if player.health < -inv.healthChange or player.mana < -inv.manaChange or player.sanity < inv.sanityChange:
					butt.disabled = true
				else:
					butt.disabled = false'''
			
			butt.disabled = false
			
		i+=1

func display_use_item_window(idx):
	useItemWindow.visible = true
	useItemWindow.get_child(0).texture = PlayerData.inventory[idx].icon
	useItemWindow.get_child(1).index = idx
	useItemWindow.get_child(1).disabled = false
	useItemWindow.get_child(2).index = idx
	
	if PlayerData.inventory[idx].itemType == Item.itemTypes.CONSUMABLE:
		var temp:Item = PlayerData.inventory[idx]
		
		if -temp.manaChange > player.mana or -temp.healthChange > player.health or -temp.sanityChange > player.sanity:
			useItemWindow.get_child(1).disabled = true

func display_change_attack_window(idx):
	changeAttackWindow.visible = true
	changeAttackWindow.get_child(4).index = idx
	for i in 4:
		if PlayerData.attacks[i] != null:
			changeAttackWindow.get_child(i).texture = PlayerData.attacks[i].icon

func set_description(text:String):
	desc.text = text

func display_next_level_button():
	nextLevelButton.visible = true

func display_loot_window(loot:Item):
	lootWindow.visible = true
	lootItem = loot
	
	$"loot window/loot icon".texture = loot.icon

#buttons logic
func _on_att_idx_hover(idx:int):
	if(PlayerData.attacks[idx] != null):
		set_description(PlayerData.attacks[idx].get_description(player.strength, player.mindPower))

func _on_att_idx_pressed(idx):
	emit_signal("attackChosen",idx)
	emit_signal("changeTurn")

func _on_inv_idx_hover(idx):
	if PlayerData.inventory[idx] != null:
		set_description(PlayerData.inventory[idx].get_description(player))

func _on_inv_idx_pressed(idx):
		if PlayerData.inventory[idx].itemType == Item.itemTypes.CONSUMABLE or PlayerData.inventory[idx].itemType == Item.itemTypes.ARMOR:
			display_use_item_window(idx)
		else:
			display_change_attack_window(idx)

func _on_use_item_button_idx_pressed(idx):
	useItemWindow.visible = false
	emit_signal("itemUsed",idx)
	reload_ui()
	emit_signal("changeTurn")

func _on_delete_button_idx_pressed(idx):
	useItemWindow.visible = false
	changeAttackWindow.visible = false
	PlayerData.inventory[idx] = null
	reload_ui()
	emit_signal("changeTurn")

func _on_change_att_butt_idx_pressed(idx):
	PlayerData.attackSlotToChange = idx
	changeAttackWindow.visible = false
	emit_signal("itemUsed",changeAttackWindow.get_child(4).index)
	reload_ui()
	emit_signal("changeTurn")

func _on_close_button_pressed():
	useItemWindow.visible = false
	changeAttackWindow.visible = false

func _on_loot_icon_mouse_entered():
	set_description(lootItem.get_description(player))

func _on_accept_loot_button_pressed():
	if(PlayerData.add_to_inventory(lootItem.duplicate())):
		lootWindow.visible = false
	else:
		$"loot window/inventory full".visible = true
	reload_ui()

func _on_refuse_loot_button_pressed():
	lootWindow.visible = false

func _on_next_level_button_pressed():
	emit_signal("nextLevelPressed")

func _on_next_level_button_mouse_entered():
	set_description("next room")

func _on_money_mouse_entered():
	desc.text = "MONEY: "+str(PlayerData.money)
	desc.text += "\n\nmoney are used to buy things in the shop"
