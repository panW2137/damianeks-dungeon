extends TextureRect
class_name skillicon

signal indexMouseEntered(idx:int)

@export var index:int = 0

func _on_control_mouse_entered():
	emit_signal("indexMouseEntered",index)
