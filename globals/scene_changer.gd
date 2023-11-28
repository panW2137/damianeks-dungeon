extends ColorRect

@onready var animation = $AnimationPlayer

func change_scene(path:String):
	animation.play("Dark")
	await animation.animation_finished
	get_tree().change_scene_to_file(path)
	animation.play("Clear")
