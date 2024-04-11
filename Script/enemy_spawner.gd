extends Node2D

var SKULL = preload("res://Scenes/enemy_member.tscn")
var EYEBALL = preload("res://Scenes/enemy_eyeball.tscn")

var cycles = 0
var biome = 1

var randomenemyspawn = 1
var highesttypeenemy = 2
var highestlevelenemy = 1

var randomspawnlocx = 0
var randomspawnlocy = 0



func _ready():
	randomize()

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

func _process(delta):
	pass

func _on_spawn_timer_timeout():
	randomenemyspawn = randi()% highesttypeenemy + 1
	if randomenemyspawn ==1:
		spawnskullenemy()
	elif randomenemyspawn == 2:
		spawneyeenemy()
	
	randomspawnlocx = randi()% 320
	randomspawnlocy = randi()% 180
	$SpawnTimer.start()
	cycles += 1
	if cycles == 10:
		$SpawnTimer.wait_time = 3.5
	if cycles == 20:
		$SpawnTimer.wait_time = 3
	if cycles == 30:
		$SpawnTimer.wait_time = 2.5
	if cycles == 40:
		$SpawnTimer.wait_time = 2
	if cycles == 55:
		$SpawnTimer.wait_time = 1.5
	if cycles == 70:
		$SpawnTimer.wait_time = 1
