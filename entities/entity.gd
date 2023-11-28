extends Node2D
class_name Entity

@export var texture:Texture2D = preload("res://textures/debug texture.png")

@export var entityType:Globals.type = Globals.type.NONE
@export var armorType:Globals.type = Globals.type.NONE

@export var entityName:String = ""

@export var mindPower:float = 0.0
@export var strength:float = 0.0
@export var maxHealth:float = 0.0
@export var armor:float = 0.0
@export var dext:float = 0.0
@export var lootChance:int = 0

var health:float = 0.0

@onready var attackList = $attacks
@onready var sprite = $sprite
@onready var healthBar = $"health bar"

signal death
signal got_damaged(dmg:float,dmgType:Globals.type)
signal dodge
signal got_emotionaly_damaged(emotonalDmg:float)

func _ready():
	sprite.texture = texture
	health = maxHealth
	healthBar.set_bar(health,maxHealth)
	initialize()

func initialize():
	pass

#damages the entity
func damage(dmg:float,emotionalDmg:float,dmgType:Globals.type):
	#checks for dodging
	if randf_range(0.0,100.0)<dext:
		emit_signal("dodge")
		return
		
	#check if dmg type is the same type as entity and armor
	if dmgType == entityType:
		#print("same entity type, more dmg")
		dmg *= 1.25
	if dmgType == armorType:
		#print("same armor type, less dmg")
		dmg *= (100.0 - armor*1.25)/100.0
	else:
		dmg *= (100.0 - armor)/100.0
	#change dmg to zero if it's below zero
	if dmg<0:
		dmg = 0
	
	emit_signal("got_damaged",dmg,dmgType)
	change_health(-dmg)
	change_sanity(-emotionalDmg)

#damages entities emotion
func change_sanity(_emotionalDmg:float):
	pass

func get_random_attack():
	var childCount = attackList.get_child_count()
	var randomIndex = randi_range(0,childCount-1)
	
	var attackMaker:AttackMaker = attackList.get_child(randomIndex)
	return attackMaker.create_attack(strength,mindPower)

func get_attack(index):
	var attackMaker:AttackMaker = attackList.get_child(index)
	return attackMaker.create_attack(strength,mindPower)

func change_health(value):
	#remove health
	health += value
	if health > maxHealth:
		health = maxHealth
	
	#round the health just in case
	health = snappedf(health,0.01)
	
	#change the health bar
	healthBar.set_bar(health,maxHealth)
	
	#emit signal for getting damaged
	
	#check if entity is dead
	if health <= 0:
		emit_signal("death")

func get_description():
	var desc:String = entityName +"\n"
	desc += "--<strength: "+str(strength)+">--\n"
	desc += "--<magic: "+str(mindPower)+">--\n"
	desc += "--<armor: "+str(armor)+">--\n"
	desc += "strong against: "+Globals.get_type_name(armorType)+"\n"
	desc += "weak against: "+Globals.get_type_name(entityType)
	return desc

