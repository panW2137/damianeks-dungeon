extends Node
class_name Item

enum itemTypes {
	CONSUMABLE,
	ARMOR,
	ATTACK,
}

@export var icon:Texture2D = preload("res://textures/debug texture 3.png")
@export var itemType:itemTypes = itemTypes.CONSUMABLE

#item data
@export var itemName:String = ""
@export var itemDescription:String = ""

@export var armorProt:float = 0.0
@export var armorType:Globals.type = Globals.type.NONE

@export var manaChange:float = 0.0
@export var healthChange:float = 0.0
@export var sanityChange:float = 0.0

@onready var attackItem:AttackMaker

func use(player:Player,inventorySlot:int):
	match itemType:
		itemTypes.CONSUMABLE:
			player.change_health(healthChange)
			player.change_mana(manaChange)
			player.change_sanity(sanityChange)
			
			Globals.playerInventory[inventorySlot] = null
		itemTypes.ARMOR:
			player.change_armor(self,inventorySlot)
		itemTypes.ATTACK:
			
			attackItem = get_child(0)
			var temp = Globals.playerAttacks[Globals.attackSlotToChange]
			Globals.playerAttacks[Globals.attackSlotToChange] = attackItem
			if(temp != null):
				get_child(0).replace_by(temp)
				icon = temp.icon
			else:
				Globals.playerInventory[inventorySlot] = null
			

func get_description(player:Player):
	var desc = ""
	desc += itemName
	
	match itemType:
		itemTypes.CONSUMABLE:
			desc += "\n"
			if(healthChange != 0.0):
				desc += "--<health: "+str(healthChange)+">--\n"
			if(manaChange != 0.0):
				desc += "--<mana: "+str(manaChange)+">--\n"
			if(sanityChange != 0.0):
				desc += "--<sanity: "+str(sanityChange)+">--\n"
			desc += itemDescription
		itemTypes.ARMOR:
			desc += "\n"
			desc += "--<armor:"+str(armorProt)+">--\n"
			desc += "bonus protection from:\n"
			desc +=  "--<"+Globals.get_type_name(armorType)+">--\n"
			desc += itemDescription
		itemTypes.ATTACK:
			attackItem = get_child(0)
			desc += attackItem.get_description(player.strength,player.mindPower)
			
	
	return desc

func get_inventory_icon():
	attackItem = get_child(0)
	if !attackItem.isSpell: #m-o-r-o-n | d-e-b-i-l | b-a-k-a | i-d-i-o-t-e-s
		match attackItem.attackType:
			Globals.type.NORMAL, Globals.type.NONE:
				return "res://textures/generic attack icons/attack normal.png"
			Globals.type.FIRE:
				return "res://textures/generic attack icons/attack fire.png"
			Globals.type.WATER:
				return "res://textures/generic attack icons/attack water.png"
			Globals.type.WIND:
				return "res://textures/generic attack icons/attack wind.png"
			Globals.type.EARTH:
				return "res://textures/generic attack icons/spell earth.png"
			Globals.type.HOLY:
				return "res://textures/generic attack icons/attack holy.png"
			Globals.type.CURSED:
				return "res://textures/generic attack icons/attack cursed.png"
	else:
		match attackItem.attackType:
			Globals.type.NONE, Globals.type.NONE:
				return "res://textures/generic attack icons/spell normal.png"
			Globals.type.FIRE:
				return "res://textures/generic attack icons/spell fire.png"
			Globals.type.WATER:
				return "res://textures/generic attack icons/spell water.png"
			Globals.type.WIND:
				return "res://textures/generic attack icons/spell wind.png"
			Globals.type.EARTH:
				return "res://textures/generic attack icons/spell earth.png"
			Globals.type.HOLY:
				return "res://textures/generic attack icons/spell holy.png"
			Globals.type.CURSED:
				return "res://textures/generic attack icons/spell cursed.png"
