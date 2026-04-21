extends Node
class_name BasicAttackBase

## Base values
@export var baseCooldown : float = 1.0
@export var baseDamage : float = 5.0

## Scaling
@export var damageScaling : float = 1.0
@export var attackSpeedScaling : float = 1.0
@export var amountScaling : float = 1.0
@export var bounceScaling : float = 1.0
@export var lifeDrainScaling : float = 1.0

## The projectile scene
@export var projectileScene : PackedScene

##===============================##

###Computed Values###

func GetCooldown() -> float:
	var asMultiplier = lerpf(1.0, GlobalStats.GetStatAttackSpeed(), attackSpeedScaling)
	return maxf(0.05, baseCooldown * asMultiplier)

func GetDamage() -> float:
	return baseDamage + (GlobalStats.GetStatDamage() * damageScaling)

func GetAmount() -> int:
	return maxi(1, 1 + roundi(GlobalStats.GetStatAmount() * amountScaling))

func GetBounces() -> int:
	return maxi(0, roundi(GlobalStats.GetStatBounce() * bounceScaling))

func GetLifeDrain() -> float:
	return GlobalStats.GetStatLifeDrain() * lifeDrainScaling

###Computed Values###

##===============================##

###Firing###

func Fire(attackingService: Node, targetingService: Node, crowdSimulator: CharacterBody2D) -> void:
	var closestEnemy = targetingService.GetClosestEnemy(crowdSimulator.global_position)
	
	## No enemies on screen
	if closestEnemy == null:
		return
	
	var dmg = GetDamage()
	var bounces = GetBounces()
	var ld = GetLifeDrain()
	var amount = GetAmount()
	
	for i in range(amount):
		FireOneVolley(targetingService, attackingService, dmg, bounces, ld)
		if i < amount - 1:
			await crowdSimulator.get_tree().create_timer(0.02).timeout

func FireOneVolley(targetingService: Node, attackingService: Node, dmg: float, bounces: int, ld: float) -> void:
	for meeb in targetingService.meeblings:
		if not is_instance_valid(meeb):
			continue
		
		var projectile : ProjectileBase = projectileScene.instantiate()
		
		## Inject stats
		projectile.damage = dmg
		projectile.bouncesLeft = bounces
		projectile.lifeDrain = ld
		
		meeb.add_child.call_deferred(projectile)
		projectile.global_position = meeb.global_position
		
		var rot = meeb.rotateTowardsEnemy()
		projectile.apply_impulse(Vector2(attackingService.bulletImpulse, 0).rotated(rot))
		projectile.rotation = rot

###Firing###
