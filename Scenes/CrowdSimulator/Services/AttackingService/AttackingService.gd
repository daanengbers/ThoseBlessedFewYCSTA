extends Node

##Projectile speeds
@export var bulletImpulse: float = 200.0
@export var fireballImpulse: float = 140.0
@export var lightningImpulse: float = 200.0
@export var frostImpulse: float = 100.0

##CrowdSim and other services needed
@onready var crowdSimulator := get_parent()
@onready var targetingService := crowdSimulator.get_node("TargetingService")

##Sound effects
@onready var shootSfx: AudioStreamPlayer2D = crowdSimulator.get_node("Sounds/Shoot")
@onready var AbilitySfx: AudioStreamPlayer2D = crowdSimulator.get_node("Sounds/Bigspell")


func fireProjectile(projectileScene: PackedScene, impulse: float, AbilitySound: bool = false) -> void:
	## Get and set closest enemy
	var closestEnemy: Node2D = targetingService.GetClosestEnemy(crowdSimulator.global_position)
	Globalsettings.globalClosestEnemy = closestEnemy

	if AbilitySound:
		AbilitySfx.play()
	else:
		shootSfx.play()

	for meeb in targetingService.meeblings:
		##Check if the meebling is still valid
		if not is_instance_valid(meeb):
			continue
		
		##Create the projectile
		var projectile: RigidBody2D = projectileScene.instantiate()
		meeb.add_child.call_deferred(projectile)
		projectile.global_position = meeb.global_position

		## Set the rotation and apply impulse towards it
		var rot = meeb.rotateTowardsEnemy()
		projectile.apply_impulse(Vector2(impulse, 0).rotated(rot))
		projectile.rotation = rot


# --- Unique/special attacks ---

func SpawnPoison(poisonScene: PackedScene) -> void:
	##Play sfx
	AbilitySfx.play()
	
	for meeb in targetingService.meeblings:
		##Check if the meebling is still valid
		if not is_instance_valid(meeb):
			continue
		
		##Create the poison cloud
		var aoe: Node2D = poisonScene.instantiate()
		meeb.add_child.call_deferred(aoe)
		aoe.global_position = meeb.global_position
