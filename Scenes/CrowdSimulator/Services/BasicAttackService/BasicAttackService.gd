extends Node

@onready var crowdSimulator : CharacterBody2D = get_parent()
@onready var attackingService = crowdSimulator.get_node("AttackingService")
@onready var targetingService = crowdSimulator.get_node("TargetingService")

var equippedAttack : BasicAttackBase = null
var cooldownTimer : float = 0.0

##===============================##

###Standard Functions###

func _ready() -> void:
	for child in get_children():
		if child is BasicAttackBase:
			equippedAttack = child
			break

func _physics_process(delta: float) -> void:
	if equippedAttack == null:
		return
	if Globalsettings.inCutscene:
		return
	
	cooldownTimer = maxf(0.0, cooldownTimer - delta)
	if cooldownTimer <= 0.0:
		equippedAttack.Fire(attackingService, targetingService, crowdSimulator)
		cooldownTimer = equippedAttack.GetCooldown()

###Standard Functions###
