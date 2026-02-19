extends Node

var enemies: Array[Node2D] = []
var meeblings: Array[Node2D] = []

func RegisterEnemy(enemy: Node2D) -> void:
	if enemy != null and not enemies.has(enemy):
		enemies.append(enemy)

func UnregisterEnemy(enemy: Node2D) -> void:
	enemies.erase(enemy)

func RegisterMeebling(meebling: Node2D) -> void:
	if meebling != null and not meeblings.has(meebling):
		meeblings.append(meebling)

func UnregisterMeebling(meebling: Node2D) -> void:
	meeblings.erase(meebling)

func GetClosestEnemy(fromPos: Vector2) -> Node2D:
	var closestDistance := INF
	var closest: Node2D = null
	
	for e in enemies:
		if not is_instance_valid(e):
			continue
		if e.get("isTargetable") == false:
			continue
	
		var d := fromPos.distance_squared_to(e.global_position)
		if d < closestDistance:
			closestDistance = d
			closest = e
	
	return closest

func _on_targeting_prune_timer_timeout() -> void:
	enemies = enemies.filter(func(e): return is_instance_valid(e))
	meeblings = meeblings.filter(func(m): return is_instance_valid(m))
