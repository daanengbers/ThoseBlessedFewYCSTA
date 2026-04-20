extends ProjectileBase

## Fireball-specific vars
var canExplode : bool = false
var canLeaveFlames : bool = false

## Preloads for fireball-specific effects
#Implement later, stub for now
##var explosionScene = preload("res://Scenes/Projectiles/Fireball/FireballExplosion.tscn")
##var flameZoneScene = preload("res://Scenes/Projectiles/Fireball/FlameZone.tscn")

##===============================##

###Overrides###

##Overide of base hit function
func OnHitEnemy(enemy: Node2D) -> void:
	## Apply damage to enemy
	enemy.hp -= roundi(damage)
	enemy.hurt()
	SpawnDamageNumber()
	
	## Apply life drain if needed
	if lifeDrain > 0.0:
		ApplyLifeDrain()
	
	## Kill check
	if enemy.hp <= 0:
		enemy.kill()
	
	## When high enough level, explode on hit
	if canExplode:
		SpawnExplosion()
	
	## Destroy in the end, override bounce
	Destroy()

###Overrides###

##===============================##

###Fireball Unique###

func SpawnExplosion() -> void:
	## TODO: Instantiate explosion AOE scene at global_position
	## The explosion scene itself handles AOE damage
	## If canLeaveFlames, also spawn a lasting flame zone
	pass
	#var explosionIn = explosionScene.instantiate()
	#get_tree().current_scene.add_child.call_deferred(explosionIn)
	#explosionIn.global_position = global_position
	#
	#if canLeaveFlames:
	#	var flameZoneIn = flameZoneScene.instantiate()
	#	get_tree().current_scene.add_child.call_deferred(flameZoneIn)
	#	flameZoneIn.global_position = global_position
	#	## Scale duration with the stat
	#	flameZoneIn.duration *= Globalsettings.GetStatDuration()

###Fireball Unique###


##===============================##

##===============================##

###Signals###

func _on_hitbox_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		OnHitEnemy(area.get_parent())

func _on_queue_timer_timeout():
	queue_free()

###Signals###
