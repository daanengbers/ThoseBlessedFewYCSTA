extends RigidBody2D
class_name ProjectileBase

## Stats injected at spawn time by the attack that fires this projectile
var damage : float = 0.0
var bouncesLeft : int = 0
var lifeDrain : float = 0.0
var destroyOnImpact : bool = true

## Internal
var randomDirection : float = 0.0
var damageNumberScene = GameResources.damageNumberScene

##===============================##

###Standard Functions###

func _ready() -> void:
	set_as_top_level(true)
	ChangeRandomDirection()

###Standard Functions###

##===============================##

###Hit Handling###

func OnHitEnemy(enemy: Node2D) -> void:
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
	
	## Bounce or destroy
	if destroyOnImpact:
		if bouncesLeft >= 1:
			Bounce()
		else:
			Destroy()

func Destroy() -> void:
	queue_free()

func Bounce() -> void:
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	apply_impulse(Vector2(200, 0).rotated(randomDirection))
	rotation = randomDirection
	$QueueTimer.start(3)
	ChangeRandomDirection()
	bouncesLeft -= 1

func ApplyLifeDrain() -> void:
	var healAmount := roundi(damage * lifeDrain)
	if healAmount <= 0:
		return

	## Structural — must exist
	var crowdSim = get_tree().get_first_node_in_group("CrowdSimulation")
	var targetingService = crowdSim.get_node("TargetingService")
	
	## Valid game state: no meeblings alive
	if targetingService.meeblings.size() == 0:
		return
	
	var closestMeeb : Node2D = null
	var closestDist := INF
	for meeb in targetingService.meeblings:
		if not is_instance_valid(meeb):
			continue
		var dist := global_position.distance_squared_to(meeb.global_position)
		if dist < closestDist:
			closestDist = dist
			closestMeeb = meeb
	
	if closestMeeb != null and is_instance_valid(closestMeeb):
		closestMeeb.hp = mini(closestMeeb.hp + healAmount, closestMeeb.maxHp)

###Hit Handling###

##===============================##

###Helpers###

func SpawnDamageNumber() -> void:
	var dmgNum = damageNumberScene.instantiate()
	get_parent().get_parent().add_child.call_deferred(dmgNum)
	dmgNum.position = global_position
	dmgNum.dmg_value = roundi(damage)

func ChangeRandomDirection() -> void:
	randomDirection = randf() * TAU

###Helpers###

##===============================##
