extends Node2D

@onready var player:Player = $player
@onready var enemy:Enemy = $enemy
@onready var ui = $ui
@onready var screenBlock = $"screen block"

var turn:bool = false
var playerDead:bool = false
var enemyDead:bool = false

func _ready():
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
	enemyDead = true
	if randi_range(1,100)<=enemy.lootChance:
		var loot = enemy.get_random_loot()
		ui.display_loot_window(loot)

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
		var attack = Globals.playerAttacks[index].create_attack(player.strength,player.mindPower)
		
		player.change_health(-Globals.playerAttacks[index].healthCost)
		player.change_sanity(-Globals.playerAttacks[index].emotionalCost)
		player.change_mana(-Globals.playerAttacks[index].manaCost)
		
		enemy.damage(attack[1],attack[2],attack[3])
		
		ui.reload_ui()

func _on_enemy_mouse_detect_mouse_entered():
	ui.set_description(enemy.get_description())

func _on_player_mouse_detect_mouse_entered():
	ui.set_description(player.get_description())

func _on_ui_item_used(index):
	Globals.playerInventory[index].use(player,index)
	ui.reload_ui()
