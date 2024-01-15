extends Node2D

@onready var animation = $AnimationPlayer

func _on_exit_pressed():
	get_tree().quit()

func _on_return_pressed():
	animation.play_backwards("move camera")

func _on_play_pressed():
	SceneChanger.change_scene("res://menus/level_select.tscn")
	#animation.play("move camera")
