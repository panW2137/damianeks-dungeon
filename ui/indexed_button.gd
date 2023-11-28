extends Button
class_name  IndexedButon

@export var index:int = 0

signal idx_pressed(idx:int)

signal idx_hover(idx:int)

func _pressed():
	emit_signal("idx_pressed",index)

func _process(_delta):
	if is_hovered():
		emit_signal("idx_hover",index)
