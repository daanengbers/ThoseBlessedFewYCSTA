extends CharacterBody2D

@onready var animator = $Anim
@onready var arrowImpact = preload("res://Scenes/ArrowImpact.tscn")
var arrow

func _ready():
	set_as_top_level(true)
	animator.play("ArrowFromAboveAnim")
	removeSelf()

func impact():
	
	pass

func removeSelf():
	await get_tree().create_timer(3.0).timeout
	
	var arrowImpactIn = arrowImpact.instantiate()
	arrow = get_tree().get_first_node_in_group("CrowdSimulation")
	arrowImpactIn.global_position = global_position
	arrow.add_child.call_deferred(arrowImpactIn)
	queue_free()

