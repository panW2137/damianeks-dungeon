extends Entity
class_name Enemy

@onready var loot = $loot
@onready var attackIcons = $"attack icons"

@export var baseMoneyLoot:float = 100.0
@export var moneyLootVariation:float = 0.25
var moneyLoot:float = 0.0

signal setAttackDescription(description:String)

func get_random_loot():
	if loot.get_child_count() != 0:
		return loot.get_children().pick_random()

func initialize():
	moneyLoot += round(baseMoneyLoot*(1+randf_range(-moneyLootVariation,moneyLootVariation)))
	
	for i in attackList.get_child_count():
		var attMak:AttackMaker = attackList.get_child(i)
		var attIco:skillicon = attackIcons.get_child(i)
		
		attIco.visible = true
		attIco.index = i
		attIco.texture = attMak.icon
		
		attIco.indexMouseEntered.connect(_on_icon_index_mouse_entered)

func _on_icon_index_mouse_entered(idx):
	emit_signal("setAttackDescription",attackList.get_child(idx).get_description(strength,mindPower))

