extends ColorRect

@export var saveName:String = ""


func _on_load_button_pressed():
	SaveHandle.load_save(saveName+".txt")

func _on_delete_button_pressed():
	#SaveHandle.delete_save(saveName+".txt")
	SaveHandle.save_save(saveName+".txt")

func _on_new_save_button_pressed():
	SaveHandle.delete_save(saveName+".txt")
