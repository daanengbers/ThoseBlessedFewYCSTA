extends AbilityBase
class_name LightningAbility

@export var levelToStartPiercing : int = 3

var lightningAmount : int = 1
var canPierce : bool = false

func Cast(crowdSimulator: CharacterBody2D, attackService: Node) -> void:
	##Get the targeting service
	var targetingService = crowdSimulator.get_node("TargetingService")
	
	##Use the targeting service to get the closest enemy
	var closestEnemy = targetingService.GetClosestEnemy(crowdSimulator.global_position)
	
	##If there are no enemies, return
	if closestEnemy == null:
		return
	
	##Set the amount of lightning bolts per level
	if currentLevel >= 2 && currentLevel < 3: 
		lightningAmount = 2
	if currentLevel >= 3 && currentLevel < 5: 
		lightningAmount = 4
	
	##Make the ability pierce above a certain level
	canPierce = currentLevel >= levelToStartPiercing
	
	##For each meeb
	for meeb in targetingService.meeblings:
		##Check if meeb is valid, if not stop cast
		if not is_instance_valid(meeb):
			continue
	
		##Get rotation from meeb to enemy
		var baseRot = meeb.rotateTowardsEnemy()
	
		##For each bolt to be fired
		for i in range(lightningAmount):
			##Set a slight spread
			var spread = deg_to_rad((i - (lightningAmount - 1) / 2.0) * 8.0)
			
			##adjust the rotation with spread in mind
			var rot = baseRot + spread
			
			var lightningBoltIn = SpawnProjectileFromMeebling(meeb, crowdSimulator.lightningBolt, attackService.lightningImpulse, rot)

			# If your projectile script supports it:
			# proj.canPierce = canPierce
