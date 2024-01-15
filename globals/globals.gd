extends Node
class_name GlobalClass

var maxLevel = 0

var priceModifiers:Array[int] = [2,2,2,2,2]

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

