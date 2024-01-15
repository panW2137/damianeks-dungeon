extends Node
class_name PlayerInfo

var attacks:Array[AttackMaker] = [null,null,null,null]

var inventory:Array[Item]
var inventorySize = 20
var attackSlotToChange:int = 0 #what have i done to this poor code

var health:float = 100.0
var maxHealth:float = 100.0

var mana:float = 100.0
var maxMana:float = 100.0

var sanity:float = 100.0
var maxSanity:float = 100.0

var strength:float = 0.0
var mindPower:float = 0.0
var armor:float = 15.0

var armorItem:Item = preload("res://items/default_armor.tscn").instantiate()

var money:float = 500.0

func _process(_delta):
	money = snappedf(money,0.01)

func _ready():
	attacks[0] = load("res://attacks/prayer.tscn").instantiate()
	attacks[1] = load("res://attacks/fireball.tscn").instantiate()
	attacks[2] = load("res://attacks/wind_slash.tscn").instantiate()
	attacks[3] = load("res://attacks/stick_beatin.tscn").instantiate()
	
	
	for i in inventorySize:
		inventory.push_front(null)
	
func add_to_inventory(item:Item):
	#why it doesn't work with for i in playerInventory?????
	for i in inventory.size():
		if inventory[i] == null:
			inventory[i] = item
			return true
	return false

func max_all_stats():
	health = maxHealth
	mana = maxMana
	sanity = maxSanity

func save_player_data(pl:Player):
	health = pl.health
	mana = pl.mana
	sanity = pl.sanity
	armorItem = pl.armorItem
	
	strength = pl.strength
	mindPower = pl.mindPower

func load_player_data(pl:Player):
	pl.health = health
	pl.mana = mana
	pl.sanity = sanity
	pl.armorItem = armorItem
	
	pl.strength = strength
	pl.mindPower = mindPower
