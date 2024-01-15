extends Sprite2D

enum s {
	FAST,
	NORMAL,
	SLOW
}

@onready var animation = $AnimationPlayer
@export var speed:s = s.NORMAL

func _ready():
	match speed:
		s.FAST:
			animation.play("rotate fast")
		s.NORMAL:
			animation.play("rotate")
		s.SLOW:
			animation.play("rotate slow")
