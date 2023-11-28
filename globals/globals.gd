extends Node

enum type {
	FIRE,
	WATER,
	WIND,
	EARTH,
	HOLY,
	CURSED,
	NORMAL,
	NONE,
}

func get_type_name(t:type):
	match t:
		type.FIRE:
			return "fire"
		type.WATER:
			return "water"
		type.WIND:
			return "wind"
		type.EARTH:
			return "earth"
		type.HOLY:
			return "holy"
		type.CURSED:
			return "cursed"
		type.NORMAL:
			return "normal"
		type.NONE:
			return "none"

var playerAttacks:Array[AttackMaker] = [null,null,null,null]

var playerInventory:Array[Item]
var inventorySize = 20
var attackSlotToChange:int = 0 #what have i done to this poor code

func _ready():
	
	playerAttacks[0] = load("res://attacks/blood_sacrifice.tscn").instantiate()
	playerAttacks[1] = load("res://attacks/fireball.tscn").instantiate()
	playerAttacks[2] = load("res://attacks/wind_slash.tscn").instantiate()
	playerAttacks[3] = load("res://attacks/stick_beatin.tscn").instantiate()
	
	
	for i in inventorySize:
		playerInventory.push_front(load("res://items/item.tscn").instantiate())
	
	playerInventory[4] = load("res://items/item.tscn").instantiate()
	playerInventory[7] = load("res://items/test_armor_2.tscn").instantiate()
	playerInventory[10] = preload("res://items/test_attack_item.tscn").instantiate()
	
func add_to_inventory(item:Item):
	#why it doesn't work with for i in playerInventory?????
	for i in playerInventory.size():
		if playerInventory[i] == null:
			playerInventory[i] = item
			return true
	return false
