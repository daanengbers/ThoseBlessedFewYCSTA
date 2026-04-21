extends AbilityBase
class_name LightningAbility

@export var levelToStartPiercing : int = 3
@export var baseLightningAmount : int = 1

func Cast(crowdSimulator: CharacterBody2D, attackService: Node) -> void:
	var targetingService = GetTargetingService(crowdSimulator)
	
	var closestEnemy = targetingService.GetClosestEnemy(crowdSimulator.global_position)
	if closestEnemy == null:
		return
	
	## Lightning bolt count scales with level
	var lightningAmount = baseLightningAmount
	if currentLevel >= 2:
		lightningAmount = 2
	if currentLevel >= 3:
		lightningAmount = 4
	
	## Pierce above a certain level
	var canPierce := currentLevel >= levelToStartPiercing
	var canChainStrike := currentLevel >= levelToStartPiercing
	
	for meeb in targetingService.meeblings:
		if not is_instance_valid(meeb):
			continue
		
		var baseRot = meeb.rotateTowardsEnemy()
		
		for i in range(lightningAmount):
			var spread = deg_to_rad((i - (lightningAmount - 1) / 2.0) * 8.0)
			var rot = baseRot + spread
			
			var boltIn = SpawnProjectileFromMeebling(meeb, GameResources.lightningBoltScene, attackService.lightningImpulse, rot)
			
			## Inject stats from scaling system
			InjectStats(boltIn)
			
			## Set lightning-specific properties
			boltIn.canPierce = canPierce
			boltIn.pierceCount = 3 if canPierce else 0
			boltIn.canChainStrike = canChainStrike
