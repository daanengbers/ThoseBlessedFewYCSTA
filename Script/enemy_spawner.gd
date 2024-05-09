extends Node2D

var SKULL = preload("res://Scenes/enemy_skull.tscn")
var EYEBALL = preload("res://Scenes/enemy_eyeball.tscn")
var SLIME = preload("res://Scenes/enemy_slime.tscn")
var GHOST = preload("res://Scenes/enemy_ghost.tscn")

var level = 1

var secconds = Globalsettings.g_seconds
var biome = 1

var randomenemyspawn = 1
var highesttypeenemy = 4
var highestlevelenemy = 1

var randomspawnlocx = 0
var randomspawnlocy = 0



func _ready():
	randomize()

func _process(_delta):
	$Label.set_text(str(secconds))

func spawnskullenemy():
	var sk = SKULL.instantiate()
	get_parent().get_parent().get_node("Ysorter").add_child.call_deferred(sk)
	var randomtoporside = randi()%4 + 1
	if randomtoporside == 1:
		sk.position.x = global_position.x + randomspawnlocx
		sk.position.y = global_position.y - 40
	if randomtoporside == 2:
		sk.position.x = global_position.x + randomspawnlocx
		sk.position.y = global_position.y + 220
	if randomtoporside == 3:
		sk.position.x = global_position.x - 40
		sk.position.y = global_position.y + randomspawnlocy
	if randomtoporside == 4:
		sk.position.x = global_position.x + 360
		sk.position.y = global_position.y + randomspawnlocy

func spawneyeenemy():
	var ey = EYEBALL.instantiate()
	get_parent().get_parent().add_child.call_deferred(ey)
	var randomtoporside = randi()%4 + 1
	if randomtoporside == 1:
		ey.position.x = global_position.x + randomspawnlocx
		ey.position.y = global_position.y - 40
	if randomtoporside == 2:
		ey.position.x = global_position.x + randomspawnlocx
		ey.position.y = global_position.y + 220
	if randomtoporside == 3:
		ey.position.x = global_position.x - 40
		ey.position.y = global_position.y + randomspawnlocy
	if randomtoporside == 4:
		ey.position.x = global_position.x + 360
		ey.position.y = global_position.y + randomspawnlocy

func spawnslimeenemy():
	var sl = SLIME.instantiate()
	get_parent().get_parent().add_child.call_deferred(sl)
	var randomtoporside = randi()%4 + 1
	if randomtoporside == 1:
		sl.position.x = global_position.x + randomspawnlocx
		sl.position.y = global_position.y - 40
	if randomtoporside == 2:
		sl.position.x = global_position.x + randomspawnlocx
		sl.position.y = global_position.y + 220
	if randomtoporside == 3:
		sl.position.x = global_position.x - 40
		sl.position.y = global_position.y + randomspawnlocy
	if randomtoporside == 4:
		sl.position.x = global_position.x + 360
		sl.position.y = global_position.y + randomspawnlocy

func spawnghostenemy():
	var gh = GHOST.instantiate()
	get_parent().get_parent().add_child.call_deferred(gh)
	var randomtoporside = randi()%4 + 1
	if randomtoporside == 1:
		gh.position.x = global_position.x + randomspawnlocx
		gh.position.y = global_position.y - 40
	if randomtoporside == 2:
		gh.position.x = global_position.x + randomspawnlocx
		gh.position.y = global_position.y + 220
	if randomtoporside == 3:
		gh.position.x = global_position.x - 40
		gh.position.y = global_position.y + randomspawnlocy
	if randomtoporside == 4:
		gh.position.x = global_position.x + 360
		gh.position.y = global_position.y + randomspawnlocy

func _on_second_timer_timeout():
	pass
	#secconds = Globalsettings.g_seconds
	#$SecondTimer.start()
	#if secconds == 10:
	#	$SpawnTimer.wait_time = 3.5
	#if secconds == 20:
	#	$SpawnTimer.wait_time = 2.8
	#if secconds == 30:
	#	$SpawnTimer.wait_time = 2.7
	#if secconds == 40:
	#	$SpawnTimer.wait_time = 2.6
	#if secconds == 60:
	#	$SpawnTimer.wait_time = 2.4
	#if secconds == 75:
	#	$SpawnTimer.wait_time = 2.2
	#if secconds == 90:
	#	$SpawnTimer.wait_time = 1.7
	#if secconds == 105:
	#	$SpawnTimer.wait_time = 1.5
	#if secconds == 120:
	#	$SpawnTimer.wait_time = 1.3
	#if secconds == 140:
	#	$SpawnTimer.wait_time = 1
	#if secconds == 200:
	#	highesttypeenemy += 1
	#	$SpawnTimer.wait_time = 0.7
	#if secconds == 400:
	#	$SpawnTimer.wait_time = 0.4
	#if secconds == 600:
	#	$SpawnTimer.wait_time = 0.2
	#if secconds == 900:
	#	$SpawnTimer.wait_time = 0.01

func _on_spawn_timer_timeout():
	randomenemyspawn = randi()% highesttypeenemy + 1
	if randomenemyspawn ==1:
		spawnskullenemy()
	if randomenemyspawn == 2:
		spawneyeenemy()
	if randomenemyspawn == 3:
		spawnslimeenemy()
	if randomenemyspawn == 3:
		spawnghostenemy()
	
	randomspawnlocx = randi()% 320
	randomspawnlocy = randi()% 180
	$SpawnTimer.start()


func _on_level_timer_timeout():
	level += 1
	if level == 2:
		$SpawnTimer.wait_time = 3.5
	if level == 3:
		$SpawnTimer.wait_time = 3.3
		highesttypeenemy += 1 # Eyeball enemies
	if level == 4:
		$SpawnTimer.wait_time = 3.1
	if level == 5:
		$SpawnTimer.wait_time = 3
	if level == 6:
		$SpawnTimer.wait_time = 2.8
	if level == 8:
		$SpawnTimer.wait_time = 2.6
	if level == 10:
		$SpawnTimer.wait_time = 2.4
	if level == 12:
		$SpawnTimer.wait_time = 2.2
	if level == 14:
		$SpawnTimer.wait_time = 2
	if level == 16:
		$SpawnTimer.wait_time = 1.8
	if level == 18:
		$SpawnTimer.wait_time = 1.6
		highesttypeenemy += 1 # Slime enemies
	if level == 20:
		$SpawnTimer.wait_time = 1.4
	if level == 22:
		$SpawnTimer.wait_time = 1.2
	if level == 24:
		$SpawnTimer.wait_time = 1
	if level == 26:
		$SpawnTimer.wait_time = 0.9
	if level == 28:
		$SpawnTimer.wait_time = 0.8
	if level == 30:
		$SpawnTimer.wait_time = 0.7
	if level == 32:
		$SpawnTimer.wait_time = 0.6
	if level == 34:
		$SpawnTimer.wait_time = 0.5
	if level == 36:
		$SpawnTimer.wait_time = 0.4
	if level == 38:
		$SpawnTimer.wait_time = 0.3
	if level == 40:
		$SpawnTimer.wait_time = 0.2
	if level == 42:
		$SpawnTimer.wait_time = 0.1
	
	
	
	$LevelTimer.start()
