extends Node2D
class_name  dungeonMaster

@export var dungeonList:Array[PackedScene]
@export var bossFight:PackedScene
@export var enterCutscene:PackedScene
@export var exitCutscene:PackedScene
@export var minRoomCount:int = 0
@export var maxRoomCount:int = 0
@export var newMaxLevel = 0

var dungeon:Dungeon
var roomLimit:int = 0
var roomCount:int = 0

func _ready():
	randomize()
	generate_random_room()
	roomLimit = randi_range(minRoomCount,maxRoomCount)
	print("room limit: ",roomLimit)

func generate_random_room():
	print("generating room")
	print("room ",roomCount)
	
	dungeon = dungeonList.pick_random().duplicate().instantiate()
	dungeon.roomExited.connect(_on_room_exited)
	add_child(dungeon)
	
	

func _on_room_exited():
	roomCount += 1
	
	get_child(0).queue_free()
	
	if roomCount < roomLimit:
		generate_random_room()
	elif roomCount == roomLimit:
		print("bossfight")
		dungeon = bossFight.duplicate().instantiate()
		dungeon.roomExited.connect(_on_room_exited)
		add_child(dungeon)
	else:
		#change later
		if Globals.maxLevel < newMaxLevel:
			Globals.maxLevel += 1
		SceneChanger.change_scene("res://menus/level_select.tscn")
