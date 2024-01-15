extends Node2D

@onready var bg = $bg
@onready var levelSelectButton = $"level select button"
@onready var levelLocked = $"level locked"

var selectedLevelIndex = 0
var dungeonScenes:Array[String] = []
var dungeonNames:Array[String] = ["haunted forest","dark castle","another world"]

@export var dungeonBackgrounds:Array[Texture] = []

func _ready():
	PlayerData.max_all_stats()
	dungeonScenes.push_back("res://dungeons/dungeon_forest.tscn")
	dungeonScenes.push_back("res://dungeons/dungeon_castle.tscn")
	dungeonScenes.push_back("res://dungeons/dungeon_dimension.tscn")
	update_level_select_display()

func update_level_select_display():
	bg.texture = dungeonBackgrounds[selectedLevelIndex]
	levelSelectButton.text = dungeonNames[selectedLevelIndex]
	if Globals.maxLevel < selectedLevelIndex:
		levelLocked.visible = true
	else:
		levelLocked.visible = false
	

func _on_shop_pressed():
	SceneChanger.change_scene("res://menus/shop.tscn")

func _on_level_select_button_pressed():
	SceneChanger.change_scene(dungeonScenes[selectedLevelIndex])

func _on_next_level_button_pressed():
	selectedLevelIndex += 1
	if selectedLevelIndex == dungeonScenes.size():
		selectedLevelIndex = 0
	update_level_select_display()

func _on_previous_level_button_pressed():
	selectedLevelIndex -= 1
	if selectedLevelIndex < 0:
		selectedLevelIndex = dungeonScenes.size() - 1
	update_level_select_display()


func _on_skill_points_button_pressed():
	SceneChanger.change_scene("res://menus/skill_level.tscn")


func _on_return_button_pressed():
	SceneChanger.change_scene("res://menus/main_menu.tscn")
