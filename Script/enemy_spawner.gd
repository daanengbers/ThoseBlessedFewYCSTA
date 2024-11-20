extends Node2D

var SKULL = preload("res://Scenes/enemy_skull.tscn")
var EYEBALL = preload("res://Scenes/enemy_eyeball.tscn")
var SLIME = preload("res://Scenes/enemy_slime.tscn")
var GHOST = preload("res://Scenes/enemy_ghost.tscn")
var SCARAB = preload("res://Scenes/enemy_scarab.tscn")
var LESTER = preload("res://Scenes/enemy_lesterskeleton.tscn")

var level = 1

var secconds = Globalsettings.g_seconds
var biome = 1

var lesterCooldown = false

var randomenemyspawn = 1
var highesttypeenemy = 1
var highestlevelenemy = 1
var amountToSpawn = 1

var randomspawnlocx = 0
var randomspawnlocy = 0

var randomLesterNumber

var max_enemies = 300

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
	sk.hp = sk.hp + (level/4)
	sk.SPEED = sk.SPEED + (level/5)

func spawneyeenemy():
	var ey = EYEBALL.instantiate()
	get_parent().get_parent().get_node("Ysorter").add_child.call_deferred(ey)
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
	ey.hp = ey.hp + (level/2)
	ey.SPEED = ey.SPEED + (level/5)

func spawnslimeenemy():
	var sl = SLIME.instantiate()
	get_parent().get_parent().get_node("Ysorter").add_child.call_deferred(sl)
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
	sl.hp = sl.hp + (level/2)
	sl.SPEED = sl.SPEED + (level/7)

func spawnghostenemy():
	var gh = GHOST.instantiate()
	get_parent().get_parent().get_node("Ysorter").add_child.call_deferred(gh)
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

func spawnscarabenemy():
	var sc = SCARAB.instantiate()
	get_parent().get_parent().get_node("Ysorter").add_child.call_deferred(sc)
	var randomtoporside = randi()%4 + 1
	if randomtoporside == 1:
		sc.position.x = global_position.x + randomspawnlocx
		sc.position.y = global_position.y - 40
	if randomtoporside == 2:
		sc.position.x = global_position.x + randomspawnlocx
		sc.position.y = global_position.y + 220
	if randomtoporside == 3:
		sc.position.x = global_position.x - 40
		sc.position.y = global_position.y + randomspawnlocy
	if randomtoporside == 4:
		sc.position.x = global_position.x + 360
		sc.position.y = global_position.y + randomspawnlocy
	sc.hp += level
	
func spawnLester():
	var sc = LESTER.instantiate()
	get_parent().get_parent().get_node("Ysorter").add_child.call_deferred(sc)
	var randomtoporside = randi()%4 + 1
	if randomtoporside == 1:
		sc.position.x = global_position.x + randomspawnlocx
		sc.position.y = global_position.y - 40
	if randomtoporside == 2:
		sc.position.x = global_position.x + randomspawnlocx
		sc.position.y = global_position.y + 220
	if randomtoporside == 3:
		sc.position.x = global_position.x - 40
		sc.position.y = global_position.y + randomspawnlocy
	if randomtoporside == 4:
		sc.position.x = global_position.x + 360
		sc.position.y = global_position.y + randomspawnlocy
	sc.hp += level

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
	for i in amountToSpawn:
		randomenemyspawn = randi()% highesttypeenemy + 1
		randomLesterNumber = randi_range(0,50)
		if get_tree().get_nodes_in_group("enemy_m").size() < max_enemies:
			if randomenemyspawn == 1:
				spawnskullenemy()
				print("meeblingamount = " + str(get_tree().get_nodes_in_group("crowd_m").size()))
			if randomenemyspawn == 2:
				spawneyeenemy()
			if randomenemyspawn == 3:
				if get_tree().get_nodes_in_group("crowd_m").size() <= 5:
					if randomLesterNumber >= 40 && lesterCooldown == false:
						lesterCooldown = true
						$LesterTimer.start(100)
						spawnLester()
					else:
						spawnslimeenemy()
				else: 
						spawnslimeenemy()
			if randomenemyspawn == 4:
				spawnghostenemy()
			if randomenemyspawn == 5:
				spawnscarabenemy()
	
	randomspawnlocx = randi()% 320
	randomspawnlocy = randi()% 180
	$SpawnTimer.start()


func _on_level_timer_timeout():
	level += 1
	if level == 2:
		$SpawnTimer.wait_time = 3.5
	if level == 3:
		$SpawnTimer.wait_time = 3.3
	if level == 4:
		$SpawnTimer.wait_time = 2.8
	if level == 5:
		$SpawnTimer.wait_time = 2.6
	if level == 6:
		$SpawnTimer.wait_time = 2.4
		highesttypeenemy += 1 # Eyeball enemies
	if level == 8:
		$SpawnTimer.wait_time = 2.3
	if level == 10:
		$SpawnTimer.wait_time = 2.1
	if level == 12:
		amountToSpawn +=1
		highesttypeenemy += 1
		$SpawnTimer.wait_time = 2
	if level == 14:
		$SpawnTimer.wait_time = 1.9
	if level == 16:
		$SpawnTimer.wait_time = 1.6
	if level == 18:
		$SpawnTimer.wait_time = 1.5
	if level == 20:
		$SpawnTimer.wait_time = 1.4
	if level == 22:
		$SpawnTimer.wait_time = 1.2
	if level == 24:
		$SpawnTimer.wait_time = 1
		highesttypeenemy += 1 # Slime enemies
	if level == 26:
		$SpawnTimer.wait_time = 0.9
	if level == 28:
		amountToSpawn +=1
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
	if level == 44:
		$SpawnTimer.wait_time = 0.09
	if level == 46:
		$SpawnTimer.wait_time = 0.08
	if level == 48:
		$SpawnTimer.wait_time = 0.07
	if level == 50:
		highesttypeenemy += 1 # Scarab enemies
		$SpawnTimer.wait_time = 0.06
	if level == 52:
		$SpawnTimer.wait_time = 0.05
	if level == 54:
		$SpawnTimer.wait_time = 0.04
	if level == 56:
		$SpawnTimer.wait_time = 0.03
	if level == 58:
		$SpawnTimer.wait_time = 0.02
	if level == 60:
		$SpawnTimer.wait_time = 0.01
	
	
	$LevelTimer.start()


func _on_lester_timer_timeout():
	lesterCooldown = false
	pass # Replace with function body.
