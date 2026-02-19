extends Node2D

@onready var crowdSimulator = get_tree().get_first_node_in_group("CrowdSimulation")
@onready var targetingService = get_tree().get_first_node_in_group("CrowdSimulation").get_node("TargetingService")

@export var hp = 30

func _ready() -> void:
	targetingService.RegisterEnemy(self)

func hurt() -> void:
	$CageAnim.play("HurtAnim")
	
func kill() -> void:
	crowdSimulator.birthMeebling(global_position)
	queue_free()

func _exit_tree() -> void:
	targetingService.UnregisterEnemy(self)
