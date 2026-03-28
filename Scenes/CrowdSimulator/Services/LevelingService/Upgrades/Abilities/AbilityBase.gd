extends UpgradeBase
class_name AbilityBase

@export var abilityId : int = 0

@export var baseCooldown : float = 1.0
@export var cooldownReductionPerLevel : Array[float] = [0]

func _ready():
	add_to_group("Upgrades")

func Cast(crowdSimulator: CharacterBody2D, attackService: Node) -> void:
	pass

func GetCooldown() -> float:
	return baseCooldown - cooldownReductionPerLevel[currentLevel - 1]

func GetTargetingService(crowdSimulator: CharacterBody2D) -> Node:
	return crowdSimulator.get_node("TargetingService")

func GetClosestEnemy(crowdSimulator: CharacterBody2D) -> Node2D:
	var targetingService = GetTargetingService(crowdSimulator)
	return targetingService.GetClosestEnemy(crowdSimulator.global_position)

func SpawnProjectileFromMeebling(meeb: Node2D, projectileScene: PackedScene, impulse: float, rotation: float) -> RigidBody2D:
	var projectile: RigidBody2D = projectileScene.instantiate()
	meeb.add_child.call_deferred(projectile)
	projectile.global_position = meeb.global_position
	projectile.rotation = rotation
	projectile.apply_impulse(Vector2(impulse, 0).rotated(rotation))
	return projectile
