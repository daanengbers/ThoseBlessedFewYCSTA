extends Node2D

@export var bossName : String

var birdBoss = preload("res://Scenes/Bosses/BirdBoss/BossBase/BossBase.tscn")

func _on_enter_square_area_entered(area):
	if area.is_in_group("Arrow"):
		match bossName:
			"Bird":
				BirdBoss()

func BirdBoss():
	##Stops player movement/attacking and enemy spawner
	Globalsettings.inCutscene = true
	Globalsettings.inBossFight = true
	Globalsettings.setmusic()
	Globalsettings.globalmusic = 2
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.hp -= 9999
		enemy.hurt()
		enemy.kill()
	
	var birdBossIn = birdBoss.instantiate()
	get_tree().get_first_node_in_group("Ysorter").add_child.call_deferred(birdBossIn)

	await birdBossIn.tree_entered

	birdBossIn.position = $SpawnPos.global_position
	birdBossIn.spawnBoss()
	
	await get_tree().create_timer(6.0).timeout
	
	$".".queue_free()
