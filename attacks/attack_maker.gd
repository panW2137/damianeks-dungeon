extends Node
class_name AttackMaker

@export var attackName:String = ""
@export var baseDamage:float = 0.0
@export var baseEmotionalDamage:float = 0.0
@export var attackType:Globals.type = Globals.type.NONE

@export var healthCost:float = 0.0
@export var manaCost:float = 0.0
@export var emotionalCost:float = 0.0
@export var variation:float = 0.0

@export var icon:Texture2D = preload("res://textures/debug texture.png")
@export var bigIcon:Texture2D = preload("res://textures/debug texture.png")
@export var isSpell:bool = false

func create_attack(strength:float,mind:float):
	var dmg = 0.0
	var emotionalDmg = 0.0
	
	emotionalDmg = baseEmotionalDamage
	
	#give a value to the damage
	if isSpell:
		dmg = baseDamage * (1.0+(mind/100))
	else:
		dmg = baseDamage * (1.0+(strength/100))
	
	#randomly change the damdage
	dmg *= 1.0+randf_range(-variation,variation)
	emotionalDmg *= 1.0+randf_range(-variation,variation)
	
	#set the damage to 0 if it's negative
	if(dmg <0):
		dmg = 0
	if(emotionalDmg<0):
		emotionalDmg = 0
	
	#round the damage
	dmg = snappedf(dmg,0.01)
	emotionalDmg = snappedf(emotionalDmg,0.01)
	
	return [attackName,dmg,baseEmotionalDamage,attackType]

func get_description(strength:float, mind:float):
	var desc = ""
	var dmg:float
	desc += attackName + "\n"
	desc += "--<"+Globals.get_type_name(attackType)+" "
	if isSpell:
		desc += "spell>--\n"
		dmg = baseDamage * (1.0+(mind/100))
	else:
		dmg = baseDamage * (1.0+(strength/100))
		desc += "attack>--\n"
	
	if dmg!= 0:
		desc += "dmg: "+str(snappedf(dmg*(1.0-variation),0.01))+" - "+str(snappedf(dmg*(1.0+variation),0.01))+"\n"
	if baseEmotionalDamage != 0:
		desc += "sanity dmg: "+str(baseEmotionalDamage)+"\n \n"
	
	if manaCost >0:
		desc += "mana cost: "+str(manaCost)+"\n"
	elif manaCost <0:
		desc += "mana regen: "+str(-manaCost)+"\n"
	
	if emotionalCost >0:
		desc += "sanity cost: "+str(emotionalCost)+"\n"
	elif emotionalCost <0:
		desc += "sanity regen: "+str(-emotionalCost)+"\n"
	
	if healthCost >0:
		desc += "health cost: "+str(healthCost) +"\n"
	elif healthCost <0:
		desc += "health regen: "+str(-healthCost) +"\n"
	
	return desc
