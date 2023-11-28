extends Entity
class_name Player

@export var maxSanity:float = 0.0
@export var maxMana:float = 0.0

@onready var sanityBar = $"sanity bar"
@onready var manaBar = $"mana bar"

var sanity:float
var mana:float
var armorItem:Item = load("res://items/test_armor_1.tscn").instantiate()

func initialize():
	armorType = armorItem.armorType
	armor = armorItem.armorProt
	
	sanity = maxSanity
	mana = maxMana
	
	sanityBar.set_bar(sanity,maxSanity)
	manaBar.set_bar(mana,maxMana)

func change_armor(newArmor:Item, inventorySlot:int):
	Globals.playerInventory[inventorySlot] = armorItem
	armorItem = newArmor
	
	armorType = armorItem.armorType
	armor = armorItem.armorProt

func change_sanity(emotionalDmg:float):
	sanity += emotionalDmg
	if sanity > maxSanity:
		sanity = maxSanity
	
	sanity = snappedf(sanity,0.01)
	
	sanityBar.set_bar(sanity,maxSanity)
	
	if sanity <= 0:
		emit_signal("death")

func change_mana(value):
	mana += value
	if mana > maxMana:
		mana = maxMana
	
	mana = snappedf(mana,0.01)
	
	if(mana < 0):
		mana = 0
	
	manaBar.set_bar(mana,maxMana)
	
