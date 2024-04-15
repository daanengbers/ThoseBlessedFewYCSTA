extends Node2D

var SKULL = preload("res://Scenes/enemy_skull.tscn")
var EYEBALL = preload("res://Scenes/enemy_eyeball.tscn")
var SLIME = preload("res://Scenes/enemy_slime.tscn")

var secconds = Globalsettings.g_seconds
var biome = 1

var randomenemyspawn = 1
var highesttypeenemy = 2
var highestlevelenemy = 1

var randomspawnlocx = 0
var randomspawnlocy = 0



func _ready():
	randomize()

func _process(delta):
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
	var sk = EYEBALL.instantiate()
	get_parent().get_parent().add_child.call_deferred(sk)
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

func spawnslimeenemy():
	var sk = SLIME.instantiate()
	get_parent().get_parent().add_child.call_deferred(sk)
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

func _on_second_timer_timeout():
	secconds = Globalsettings.g_seconds
	$SecondTimer.start()
	if secconds == 10:
		$SpawnTimer.wait_time = 3.5
	if secconds == 20:
		$SpawnTimer.wait_time = 2.8
	if secconds == 30:
		$SpawnTimer.wait_time = 2.5
	if secconds == 40:
		$SpawnTimer.wait_time = 2.2
	if secconds == 60:
		$SpawnTimer.wait_time = 1.5
	if secconds == 75:
		$SpawnTimer.wait_time = 1.6
	if secconds == 90:
		$SpawnTimer.wait_time = 1.2
		highesttypeenemy += 1
	if secconds == 105:
		$SpawnTimer.wait_time = 0.9
	if secconds == 120:
		$SpawnTimer.wait_time = 0.7
	if secconds == 140:
		$SpawnTimer.wait_time = 0.5
	if secconds == 200:
		$SpawnTimer.wait_time = 0.3
	if secconds == 400:
		$SpawnTimer.wait_time = 0.2
	if secconds == 600:
		$SpawnTimer.wait_time = 0.1
	if secconds == 900:
		$SpawnTimer.wait_time = 0.01

func _on_spawn_timer_timeout():
	randomenemyspawn = randi()% highesttypeenemy + 1
	if randomenemyspawn ==1:
		spawnskullenemy()
	if randomenemyspawn == 2:
		spawneyeenemy()
	if randomenemyspawn == 3:
		spawnslimeenemy()
	randomspawnlocx = randi()% 320
	randomspawnlocy = randi()% 180
	$SpawnTimer.start()



