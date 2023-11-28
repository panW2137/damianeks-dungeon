extends Control

enum dispMode {
	PERCENT,
	VALUE_MAX_VALUE,
	VALUE,
}

@export var color:Color
@export var showLabel:bool = true
@export var mode:dispMode = dispMode.PERCENT

@onready var full = $full
@onready var label = $Label

func _ready():
	full.color = color
	label.visible = showLabel
	
func set_bar(current:float, maximum:float):
	if current < 0:
		current = 0
	var newSize:float = 64*(current/maximum)
	if newSize < 0:
		newSize = 0
	full.size.x = newSize
	
	match mode:
		dispMode.PERCENT:
			var pr = current/maximum
			pr = snapped(pr,0.0001)*100
			label.text = str(pr)+"%"
		dispMode.VALUE_MAX_VALUE:
			label.text = str(current)+"/"+str(maximum)
		dispMode.VALUE:
			label.text = str(current)

