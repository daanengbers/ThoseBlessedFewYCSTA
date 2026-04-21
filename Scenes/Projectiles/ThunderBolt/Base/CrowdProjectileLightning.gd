extends ProjectileBase

## Lightning-specific properties (set by LightningAbility.Cast())
var canPierce : bool = false
var canChainStrike : bool = false
var pierceCount : int = 0
var enemiesHit : Array[Node2D] = []

##===============================##

###Overrides###

func OnHitEnemy(enemy: Node2D) -> void:
	## Prevent hitting the same enemy twice when piercing
	if enemiesHit.has(enemy):
		return
	enemiesHit.append(enemy)
	
	## Apply damage
	enemy.hp -= roundi(damage)
	enemy.hurt()
	SpawnDamageNumber()
	
	## Life drain
	if lifeDrain > 0.0:
		ApplyLifeDrain()
	
	## Kill check
	if enemy.hp <= 0:
		enemy.kill()
	
	## Chain strike on hit
	if canChainStrike:
		SpawnChainStrikes()
	
	## Pierce or destroy (lightning never bounces)
	if canPierce and pierceCount > 0:
		pierceCount -= 1
		## Don't destroy — keep going
	else:
		Destroy()

###Overrides###

##===============================##

###Lightning Unique###

func SpawnChainStrikes() -> void:
	## Find up to 3 random nearby enemies and deal half damage
	var crowdSim = get_tree().get_first_node_in_group("CrowdSimulation")
	var targetingService = crowdSim.get_node("TargetingService")
	
	var chainRange := 60.0
	var chainTargets : Array[Node2D] = []
	
	for enemy in targetingService.enemies:
		if not is_instance_valid(enemy):
			continue
		if enemiesHit.has(enemy):
			continue
		if enemy.global_position.distance_to(global_position) <= chainRange:
			chainTargets.append(enemy)
	
	chainTargets.shuffle()
	var chainCount = mini(3, chainTargets.size())
	
	for i in range(chainCount):
		var target = chainTargets[i]
		target.hp -= roundi(damage * 0.4)
		target.hurt()
		if target.hp <= 0:
			target.kill()

###Lightning Unique###

##===============================##

###Signals###

func _on_hitbox_area_entered(area) -> void:
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		OnHitEnemy(area.get_parent())

func _on_queue_timer_timeout() -> void:
	queue_free()

###Signals###
