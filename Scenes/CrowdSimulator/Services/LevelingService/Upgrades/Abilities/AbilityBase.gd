extends UpgradeBase
class_name AbilityBase

@export var abilityId : int = 0

## Cooldown
@export var baseCooldown : float = 1.0
@export var cooldownReductionPerLevel : Array[float] = [0]

## Base values
@export var baseDamage : float = 10.0

## Scaling multipliers — how much each global stat affects THIS ability
## 1.0 = full scaling, 0.5 = half, 0.0 = no effect
@export var damageScaling : float = 1.0
@export var cdrScaling : float = 1.0
@export var bounceScaling : float = 0.0       ## 0 means no bounce
@export var amountScaling : float = 0.0       ## 0 means no amount increase
@export var lifeDrainScaling : float = 1.0
@export var durationScaling : float = 0.0     ## Only relevant for DOT/AOE abilities

##===============================##

###Standard Functions###

func _ready():
	add_to_group("Upgrades")

###Standard Functions###

##===============================##

###Computed Values###

func GetCooldown() -> float:
	##Deduct base cooldown reduction per ability level
	var baseCd := baseCooldown - cooldownReductionPerLevel[currentLevel - 1]
	## Apply CDR stat with stat scaling
	var cdrMultiplier := lerpf(1.0, GlobalStats.GetStatCDR(), cdrScaling)
	return maxf(0.5, baseCd * cdrMultiplier)

func GetDamage() -> float:
	return baseDamage + (GlobalStats.GetStatDamage() * damageScaling)

func GetBounces() -> int:
	return maxi(0, roundi(GlobalStats.GetStatBounce() * bounceScaling))

func GetAmount() -> int:
	return maxi(0, roundi(GlobalStats.GetStatAmount() * amountScaling))

func GetLifeDrain() -> float:
	return GlobalStats.GetStatLifeDrain() * lifeDrainScaling

func GetDuration() -> float:
	## Returns a multiplier for duration-based abilities
	return lerpf(1.0, GlobalStats.GetStatDuration(), durationScaling)

###Computed Values###

##===============================##

###Casting###

func Cast(crowdSimulator: CharacterBody2D, attackService: Node) -> void:
	## Override in subclasses
	pass

###Casting###

##===============================##

###Helpers###

func GetTargetingService(crowdSimulator: CharacterBody2D) -> Node:
	return crowdSimulator.get_node("TargetingService")

func GetClosestEnemy(crowdSimulator: CharacterBody2D) -> Node2D:
	var targetingService = GetTargetingService(crowdSimulator)
	return targetingService.GetClosestEnemy(crowdSimulator.global_position)

func SpawnProjectileFromMeebling(meeb: Node2D, projectileScene: PackedScene, impulse: float, rot: float) -> Node:
	var projectile = projectileScene.instantiate()
	meeb.add_child.call_deferred(projectile)
	projectile.global_position = meeb.global_position
	projectile.rotation = rot
	projectile.apply_impulse(Vector2(impulse, 0).rotated(rot))
	return projectile

## Injects the standard computed stats into a ProjectileBase instance
func InjectStats(projectile: ProjectileBase) -> void:
	projectile.damage = GetDamage()
	projectile.bouncesLeft = GetBounces()
	projectile.lifeDrain = GetLifeDrain()

## For non-ProjectileBase spawns (like poison cloud), inject manually
func InjectStatsManual(node: Node, dmg: float, ld: float) -> void:
	node.damage = dmg
	node.lifeDrain = ld

###Helpers###
