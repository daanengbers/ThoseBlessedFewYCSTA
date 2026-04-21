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

###Fireball Unique functions###

func SpawnExplosion() -> void:
	## TODO: Create a FireballExplosion.tscn scene (Area2D with collision + timer)
	## that deals AOE damage to all enemies in radius
	## For now, deal damage to nearby enemies directly
	var crowdSim = get_tree().get_first_node_in_group("CrowdSimulation")
	var targetingService = crowdSim.get_node("TargetingService")
	
	var explosionRadius := 40.0
	for enemy in targetingService.enemies:
		if not is_instance_valid(enemy):
			continue
		if enemy.global_position.distance_to(global_position) <= explosionRadius:
			enemy.hp -= roundi(damage * 0.5)
			enemy.hurt()
			if enemy.hp <= 0:
				enemy.kill()
	
	## If high enough level, leave flame zone
	if canLeaveFlames:
		SpawnFlameZone()

func SpawnFlameZone() -> void:
	## TODO: Create a FlameZone.tscn scene (Area2D that ticks damage over time)
	## For now, placeholder
	pass

###Fireball Unique functions###


##===============================##

##===============================##

###Signals###

func _on_hitbox_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		OnHitEnemy(area.get_parent())

func _on_queue_timer_timeout():
	queue_free()

###Signals###
