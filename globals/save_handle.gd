extends Node2D

var currentSaveName:String = ""

func delete_save(path):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.close()

func save_save(path):
	var file = FileAccess.open(path,FileAccess.WRITE)
	var packedScene = PackedScene.new()
	packedScene.pack(Globals)
	file.store_var(packedScene,true)
	file.close()

func load_save(path):
	var file = FileAccess.open(path,FileAccess.READ)
	var obj = file.get_var(true)
	#obj = obj.get_instance_id()
	#obj = instance_from_id(obj)
	print(obj)
	file.close()
	
	
