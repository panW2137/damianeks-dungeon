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

@export var basePrice:float = 0.0
@export var priceVariation:float = 0.25

@onready var attackItem:AttackMaker

var price = basePrice
#var price:float = snappedf(basePrice*(1+randf_range(-priceVariation,priceVariation)),0.01)

func _ready():
	price = snappedf(basePrice*(1+randf_range(-priceVariation,priceVariation)),0.01)

func set_price():
	price = snappedf(basePrice*(1+randf_range(-priceVariation,priceVariation)),0.01)

func use(player:Player,inventorySlot:int):
	match itemType:
		itemTypes.CONSUMABLE:
			player.change_health(healthChange)
			player.change_mana(manaChange)
			player.change_sanity(sanityChange)
			
			PlayerData.inventory[inventorySlot] = null
		itemTypes.ARMOR:
			player.change_armor(self,inventorySlot)
		itemTypes.ATTACK:
			
			attackItem = get_child(0)
			var temp = PlayerData.attacks[PlayerData.attackSlotToChange]
			PlayerData.attacks[PlayerData.attackSlotToChange] = attackItem
			if(temp != null):
				get_child(0).replace_by(temp)
				icon = temp.icon
			else:
				PlayerData.playerInventory[inventorySlot] = null
			

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
	if itemType == itemTypes.ATTACK:
		attackItem = get_child(0)
		return attackItem.icon
	else:
		return icon
	#debil
	#why did it take me so long to realize that i can just do this
