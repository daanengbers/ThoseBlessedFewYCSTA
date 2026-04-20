extends AbilityBase
class_name FireballAbility

##Unique vars

@export var levelToStartExploding : int = 3
@export var levelToLeaveFlames : int = 6

##===============================##

###Unique spell behaviour###

func Cast(crowdSimulator: CharacterBody2D, attackService: Node) -> void:
	var targetingService = GetTargetingService(crowdSimulator)
	
	var closestEnemy = targetingService.GetClosestEnemy(crowdSimulator.global_position)
	
	if closestEnemy == null:
		return
	
	## Determine level-based behavior
	var canExplode : bool = currentLevel >= levelToStartExploding
	var canLeaveFlames : bool = currentLevel >= levelToLeaveFlames
	
	for meeb in targetingService.meeblings:
		if not is_instance_valid(meeb):
			continue
		
		var rot = meeb.rotateTowardsEnemy()
		var fireballIn = SpawnProjectileFromMeebling(meeb, GameResources.fireBallScene, attackService.fireballImpulse, rot)
		
		## Inject stats from scaling system
		InjectStats(fireballIn)
		
		## Set fireball-specific properties
		fireballIn.canExplode = canExplode
		fireballIn.canLeaveFlames = canLeaveFlames

###Unique spell behaviour###
