extends CharacterBody2D

@export var hp : int
@export var damage : int
@export var speed : int

var arrowFromAbove = preload("res://Scenes/ArrowFromAbove.tscn")
var arrowBullet = preload("res://Scenes/bullet_fromcrowd_thunderbolt.tscn")
var markedEffect = preload("res://Scenes/MarkedEffect.tscn")

var arrow
var meeblings

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Engine.get_process_frames() % 500 == 0:
		arrowAim(10)



func ArrowRain(amountOfArrows: int):
	arrow = get_tree().get_first_node_in_group("CrowdSimulation")
	var arrowLocation = arrow.global_position
	
	for i in range(amountOfArrows):
		randomize()
		var randomX = randi_range(-160, 160)
		var randomY = randi_range(-90, 90)
		var arrowFromAboveIn = arrowFromAbove.instantiate()
		arrow.add_child.call_deferred(arrowFromAboveIn)
		arrowFromAboveIn.global_position = Vector2(arrow.global_position.x + randomX ,arrow.global_position.y + randomY)

func arrowAim(damage : int):
	randomize()
	
	meeblings = get_tree().get_nodes_in_group("meeblings")
	var randomMeeblingNumber  = randi_range(0, meeblings.size() - 1)
	var randomMeebling = meeblings[randomMeeblingNumber]
	var markedEffectIn = markedEffect.instantiate()
	randomMeebling.add_child(markedEffectIn)
	markedEffectIn.global_position = randomMeebling.global_position
	
	await get_tree().create_timer(1.0).timeout
	
	var arrowIn = arrowBullet.instantiate()
	add_child(arrowIn)
	arrowIn.global_position = global_position
	$Rot.look_at(randomMeebling.global_position)
	arrowIn.rotation = $Rot.rotation
	arrowIn.apply_impulse(Vector2(80, 0).rotated($Rot.rotation))
