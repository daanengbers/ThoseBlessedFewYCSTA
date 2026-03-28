extends AbilityBase
class_name FireballAbility

@export var levelToStartExploding : int = 3

var canExplode : bool = false

func Cast(crowdSimulator: CharacterBody2D, attackService: Node) -> void:
	##Get the targeting service
	var targetingService = crowdSimulator.get_node("TargetingService")
	
	##Use the targeting service to get the closest enemy
	var closestEnemy = targetingService.GetClosestEnemy(crowdSimulator.global_position)
	
	##If there are no enemies, return
	if closestEnemy == null:
		return
	
	##Make the ability pierce above a certain level
	canExplode = currentLevel >= levelToStartExploding
	
	##For each meeb
	for meeb in targetingService.meeblings:
		##Check if meeb is valid, if not stop cast
		if not is_instance_valid(meeb):
			continue
		
		##Get rotation from meeb to enemy
		var rot = meeb.rotateTowardsEnemy()
		
		var fireballIn = SpawnProjectileFromMeebling(meeb, crowdSimulator.fireBall, attackService.lightningImpulse, rot)
		
		fireballIn.BaseDamage += 10
		# If your projectile script supports it:
		# proj.canPierce = canPierce
