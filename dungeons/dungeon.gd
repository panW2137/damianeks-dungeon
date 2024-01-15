extends Node2D
class_name Dungeon

@onready var player:Player = $player
@onready var ui = $ui
@onready var screenBlock = $"screen block"
@onready var enemy:Enemy = $enemy

var turn:bool = false
var playerDead:bool = false
var enemyDead:bool = false
#var enemy:Enemy

signal roomExited

func _ready():
	ui.player = player
	print(player)
	randomize()
	process_turn()

func process_turn():
	ui.player = player
	ui.reload_ui()
	while(true):
		ui.reload_ui()
		#player turn
		
		if playerDead:
			break
		await ui.changeTurn
		
		#enemy turn
		if enemyDead:
			break
		ui.disable_all()
		
		#delay
		await get_tree().create_timer(0.5).timeout
		var attack = enemy.get_random_attack()
		player.damage(attack[1],attack[2],attack[3])


func _on_player_death():
	print("player is dead")
	screenBlock.visible = true
	playerDead = true
	await get_tree().create_timer(1).timeout
	SceneChanger.change_scene("res://ui/death_screen.tscn")

func _on_enemy_death():
	print("enemy is dead")
	PlayerData.money += enemy.moneyLoot
	ui.reload_ui()
	
	enemy.visible = false
	enemyDead = true
	if randi_range(1,100)<=enemy.lootChance:
		var loot = enemy.get_random_loot()
		ui.display_loot_window(loot)
	ui.display_next_level_button()
	$"enemy mouse detect".queue_free()

func _on_player_got_damaged(_dmg, _dmgType):
	#print("player damaged, damage type: ",dmgType," damage: ",dmg)
	#print("player HP: ",player.health,"\n")
	pass

func _on_enemy_got_damaged(_dmg, _dmgType):
	#print("enemy damaged, damage type: ",dmgType," damage: ",dmg)
	#print("enemy HP: ",enemy.health,"\n")
	pass

func _on_ui_attack_chosen(index):
	if !playerDead and !enemyDead:
		var attack = PlayerData.attacks[index].create_attack(player.strength,player.mindPower)
		
		player.change_health(-PlayerData.attacks[index].healthCost)
		player.change_sanity(-PlayerData.attacks[index].emotionalCost)
		player.change_mana(-PlayerData.attacks[index].manaCost)
		
		enemy.damage(attack[1],attack[2],attack[3])
		
		ui.reload_ui()

func _on_enemy_mouse_detect_mouse_entered():
	ui.set_description(enemy.get_description())

func _on_player_mouse_detect_mouse_entered():
	ui.set_description(player.get_description())

func _on_ui_item_used(index):
	PlayerData.inventory[index].use(player,index)
	ui.reload_ui()

func _on_ui_next_level_pressed():
	PlayerData.save_player_data(player)
	emit_signal("roomExited")

func _on_enemy_set_attack_description(desc):
	ui.set_description(desc)
