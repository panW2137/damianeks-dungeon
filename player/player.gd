extends Entity
class_name Player

@export var maxSanity:float = 0.0
@export var maxMana:float = 0.0

@onready var sanityBar = $"sanity bar"
@onready var manaBar = $"mana bar"

@onready var manaAnim = $"mana indicator anim"
@onready var sanityAnim = $"sanity indicator anim"

var sanity:float
var mana:float
var armorItem:Item = null

#WARNING !!!!!!!!!
#player sends dead signal 2 times for losing sanity
#and 2 times for losing health
#does not cause bugs for now
#if doesnt break game leave it and dont touch the code
#if breaks code then you have a problem
#good luck, future me
#
#update
#
#nvm, it happens only when initial stats are 0???
#actually, i have no idea what causes this bug
#welp, its your problem, future me
#screw you and have a wonderful day fixing it

func initialize():
	#load data from playerData
	maxHealth = PlayerData.maxHealth
	maxSanity = PlayerData.maxSanity
	maxMana = PlayerData.maxMana
	
	PlayerData.load_player_data(self)
	
	#initialize the player
	armorType = armorItem.armorType
	armor = armorItem.armorProt
	
	#sanity = maxSanity
	#mana = maxMana
	
	healthBar.set_bar(health,maxHealth)
	sanityBar.set_bar(sanity,maxSanity)
	manaBar.set_bar(mana,maxMana)

func change_armor(newArmor:Item, inventorySlot:int):
	PlayerData.inventory[inventorySlot] = armorItem
	armorItem = newArmor
	
	armorType = armorItem.armorType
	armor = armorItem.armorProt

func change_sanity(value:float):
	if value == 0:
		return
	
	if value>0:
		sanityAnim.play("add")
	else:
		sanityAnim.play("remove")
	
	sanity += value
	
	SanityIndicator.text = str(abs(snappedf(value,0.01)))
	
	if sanity > maxSanity:
		sanity = maxSanity
	
	sanity = snappedf(sanity,0.01)
	
	sanityBar.set_bar(sanity,maxSanity)
	
	if sanity <= 0:
		emit_signal("death")

func change_mana(value):
	if value == 0:
		return
	
	if value >0:
		manaAnim.play("add")
	else:
		manaAnim.play("remove")
	
	mana += value
	
	ManaIndicator.text = str(abs(snappedf(value,0.01)))
	
	if mana > maxMana:
		mana = maxMana
	
	mana = snappedf(mana,0.01)
	
	if(mana < 0):
		mana = 0
	
	manaBar.set_bar(mana,maxMana)
	
