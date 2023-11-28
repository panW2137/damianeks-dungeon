extends Entity
class_name Enemy

@onready var loot = $loot

func get_random_loot():
	return loot.get_children().pick_random()
