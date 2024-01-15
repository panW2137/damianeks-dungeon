extends CanvasLayer

@onready var animation:AnimationPlayer = $AnimationPlayer

func change_scene(path:String):
	animation.play("black")
	await animation.animation_finished
	get_tree().change_scene_to_file(path)
	animation.play_backwards("black")
