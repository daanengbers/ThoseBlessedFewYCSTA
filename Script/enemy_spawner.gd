extends Node2D

@onready var crowdSimulator = get_tree().get_first_node_in_group("CrowdSimulation")
@onready var targetingService = crowdSimulator.get_node("TargetingService")

@export var enabled = false

var skull = preload("res://Scenes/enemySkull.tscn")
var eyeBall = preload("res://Scenes/enemyEyball.tscn")
var slime = preload("res://Scenes/enemySlime.tscn")
var ghost = preload("res://Scenes/enemyGhost.tscn")
var scarab = preload("res://Scenes/enemy_scarab.tscn")
var lester = preload("res://Scenes/enemyLester.tscn")

var level = 1

var secconds = Globalsettings.g_seconds
var biome = 1

var lesterCooldown = false

var randomenemyspawn = 1
var highesttypeenemy = 1
var highestlevelenemy = 1
var amountToSpawn = 3

var randomspawnlocx = 0
var randomspawnlocy = 0

var randomLesterNumber

var max_enemies = 300

func _ready():
	if enabled == true:
		spawnEnemy("skull")
		spawnEnemy("skull")
		spawnEnemy("skull")

func _process(_delta):
	$Label.set_text(str(secconds))

func spawnEnemy(enemyToSpawn):
	##enemy specific stats, standard of 0 to handle uncatched values
	var hpScaling = 0
	var spScaling = 0
	
	##Instantiate enemy and child it
	var enemyIn
	match enemyToSpawn:
		"eyeBall":
			enemyIn = eyeBall.instantiate()
		"slime":
			enemyIn = slime.instantiate()
		"skull":
			enemyIn = skull.instantiate()
		"ghost":
			enemyIn = ghost.instantiate()
		"scarab":
			enemyIn = scarab.instantiate()
		"lester":
			enemyIn = lester.instantiate()
	get_tree().get_first_node_in_group("Ysorter").add_child.call_deferred(enemyIn)
	
	##Place it in a random location around the player
	randomize()
	var randomspawnlocx = randi_range(-160, 160)
	var randomspawnlocy = randi_range(-90,90)
	
	var randomtoporside = randi()%4 + 1
	
	if randomtoporside == 1:
		enemyIn.position.x = global_position.x - 170
		enemyIn.position.y = global_position.y + randomspawnlocy
	if randomtoporside == 2:
		enemyIn.position.x = global_position.x + 170
		enemyIn.position.y = global_position.y + randomspawnlocy
	if randomtoporside == 3:
		enemyIn.position.x = global_position.x + randomspawnlocx
		enemyIn.position.y = global_position.y - 100
	if randomtoporside == 4:
		enemyIn.position.x = global_position.x + randomspawnlocx
		enemyIn.position.y = global_position.y + 100
	
	##Handle scaling
	enemyIn.hp = enemyIn.hp + (level * hpScaling)
	enemyIn.speed = enemyIn.speed + (level * spScaling)

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
	if Globalsettings.inBossFight == false && Globalsettings.inCutscene == false:
		for i in amountToSpawn:
			randomenemyspawn = randi()% highesttypeenemy + 1
			randomLesterNumber = randi_range(0,50)
			randomspawnlocx = randi_range(-160, 160)
			randomspawnlocy = randi_range(-90,90)
			if targetingService.enemies.size() < max_enemies:
				if randomenemyspawn == 1:
					spawnEnemy("skull")
				if randomenemyspawn == 2:
					spawnEnemy("eyeBall")
				if randomenemyspawn == 3:
					if targetingService.meeblings.size() <= 5:
						if randomLesterNumber >= 40 && lesterCooldown == false:
							lesterCooldown = true
							$LesterTimer.start(100)
							spawnEnemy("lester")
						else:
							spawnEnemy("slime")
					else: 
							spawnEnemy("slime")
				if randomenemyspawn == 4:
					spawnEnemy("ghost")
	
	$SpawnTimer.start()


func _on_level_timer_timeout():
	if Globalsettings.inBossFight == false && Globalsettings.inCutscene == false:
		if enabled == true:
			level += 1
			match level:
				2:
					$SpawnTimer.wait_time = 3.5
				3:
					$SpawnTimer.wait_time = 3.3
				4:
					$SpawnTimer.wait_time = 2.8
				5:
					$SpawnTimer.wait_time = 2.6
					highesttypeenemy += 1 #Eyeball enemies
				6:
					$SpawnTimer.wait_time = 3
					amountToSpawn +=2
				8:
					$SpawnTimer.wait_time = 2.9
				10:
					$SpawnTimer.wait_time = 2.8
				12:
					amountToSpawn +=1
					highesttypeenemy += 1
					$SpawnTimer.wait_time = 2
				14:
					$SpawnTimer.wait_time = 1.9
				16:
					$SpawnTimer.wait_time = 1.6
				18:
					$SpawnTimer.wait_time = 1.5
					amountToSpawn +=3
				20:
					$SpawnTimer.wait_time = 1.4
				22:
					$SpawnTimer.wait_time = 1.2
				24:
					$SpawnTimer.wait_time = 1
					highesttypeenemy += 1 # Slime enemies
				26:
					$SpawnTimer.wait_time = 0.9
				28:
					amountToSpawn +=1
					$SpawnTimer.wait_time = 0.8
				30:
					$SpawnTimer.wait_time = 0.7
				32:
					$SpawnTimer.wait_time = 0.6
				34:
					$SpawnTimer.wait_time = 0.5
				36:
					$SpawnTimer.wait_time = 0.4
				38:
					$SpawnTimer.wait_time = 0.3
				40:
					$SpawnTimer.wait_time = 0.2
				42:
					$SpawnTimer.wait_time = 0.1
				44:
					$SpawnTimer.wait_time = 0.09
				46:
					$SpawnTimer.wait_time = 0.08
				48:
					$SpawnTimer.wait_time = 0.07
				50:
					highesttypeenemy += 1 # Scarab enemies
					$SpawnTimer.wait_time = 0.06
				52:
					$SpawnTimer.wait_time = 0.05
				54:
					$SpawnTimer.wait_time = 0.04
				56:
					$SpawnTimer.wait_time = 0.03
				58:
					$SpawnTimer.wait_time = 0.02
				60:
					$SpawnTimer.wait_time = 0.01
			
		$LevelTimer.start()


func _on_lester_timer_timeout():
	lesterCooldown = false
