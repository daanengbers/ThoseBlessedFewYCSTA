extends CharacterBody2D

@export var hp : int
@export var damage : int
@export var speed : int

var arrowFromAbove = preload("res://Scenes/ArrowFromAbove.tscn")
var arrowBullet = preload("res://Scenes/bullet_fromcrowd_thunderbolt.tscn")
var markedEffect = preload("res://Scenes/MarkedEffect.tscn")

var arrow
var meeblings

@export var hoverRadius: float = 100.0
@export var wanderBand: float = 40.0               
@export var moveSpeed: float = 20.0
@export var snapDistance: float = 10.0
@export var waitTimeMin: float = 0.6
@export var waitTimeMax: float = 1.4

# Hover and drift
var driftDirection: Vector2 = Vector2.RIGHT
var driftTimer: float = 0.0
@export var driftChangeDirMin: float = 0.5
@export var driftChangeDirMax: float = 1.2

# Donut band wander
var waitTimer: float = 0.0
var donutTarget: Vector2 = Vector2.ZERO

var target: Node2D = null
var orbitAngle: float = 0.0

var canFlip

##Targeting vars
var quadrant = 1
var distanceToMeebling
var meeblingToDamage
var withinReach = false

func _ready():
	PickRandomTarget()

func _process(delta):
	HoverAndDrift(delta)
	print(target)
	if Engine.get_process_frames() % 500 == 0:
		arrowAim(10)
		

func HoverAndDrift(delta: float):
	##When target is null or invalid, find a new target. If none are available, stop moving
	if target == null or not is_instance_valid(target):
		PickRandomTarget()
		if target == null or not is_instance_valid(target):
			velocity = Vector2.ZERO
			move_and_slide()
			return
	
	##Create variables for the center and the distance to the center
	var center = target.global_position
	var toCenter = center - global_position
	
	# Keep at hoverRadius
	var dist = toCenter.length()
	var push: Vector2 = Vector2.ZERO
	
	# Stay within a ring around the player
	if dist > hoverRadius + wanderBand:
		# Too far, move toward center
		push = toCenter.normalized() * moveSpeed
	elif dist < hoverRadius - wanderBand:
		# Too close, move away
		push = -toCenter.normalized() * moveSpeed * 0.7
	else:
		# Wander
		driftTimer -= delta
		if driftTimer <= 0.0:
			driftDirection = Vector2.RIGHT.rotated(randf() * TAU)
			driftTimer = randf_range(driftChangeDirMin, driftChangeDirMax)
		push = driftDirection * moveSpeed * 0.7
	
	velocity = (velocity.lerp(push, 0.15)).limit_length(moveSpeed)
	move_and_slide()

func DonutBandWander(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		PickRandomTarget()
		if target == null or not is_instance_valid(target):
			velocity = Vector2.ZERO
			move_and_slide()
			return
	
	if waitTimer > 0.0:
		waitTimer -= delta
		velocity = Vector2.ZERO
		move_and_slide()
		if waitTimer <= 0.0:
			PickNewDonutPoint()
		return
	
	# Move toward the donutTarget
	var toTarget = donutTarget - global_position
	var dist = toTarget.length()
	if dist > snapDistance:
		velocity = toTarget.normalized() * moveSpeed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		waitTimer = randf_range(waitTimeMin, waitTimeMax)

func PickRandomTarget():
	var meeblings = get_tree().get_nodes_in_group("meeblings")
	if meeblings.size() > 0:
		target = meeblings[randi() % meeblings.size()]
	else:
		target = null

func PickNewDonutPoint():
	if target == null or not is_instance_valid(target):
		return
	var angle = randf() * TAU
	var radius = hoverRadius + randf_range(-wanderBand, wanderBand)
	donutTarget = target.global_position + Vector2(radius, 0).rotated(angle)






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
