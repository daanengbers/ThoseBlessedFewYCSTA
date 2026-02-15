extends CharacterBody2D

##Services
@onready var targetingService = get_tree().get_first_node_in_group("CrowdSimulation").get_node("TargetingService")

@onready var hurtBox : Area2D = $HURTbox_Enemy

##Stats
@export var hp : int
@export var damage : int
@export var speed : int

##Attack vars
var attackArray = ["arrowAim", "arrowRain", "airSlamAttack", "arrowScatter"]

var arrowFromAbove = preload("res://Scenes/Bosses/BirdBoss/Attacks/ArrowFromAbove/ArrowFromAbove.tscn")
var arrowBullet = preload("res://Scenes/Bosses/BirdBoss/Attacks/ArrowFromCrowd/ArrowFromCrowd.tscn")
var markedEffect = preload("res://Scenes/MarkedEffect.tscn")

var isTargetable : bool = true
var attackInProgress: bool = false
var shadowInstance: Node2D = null

var arrow
var meeblings

##Movement vars
@export var hoverRadius: float = 140.0
@export var wanderBand: float = 20.0               
@export var moveSpeed: float = 40.0
@export var snapDistance: float = 10.0
@export var waitTimeMin: float = 0.6
@export var waitTimeMax: float = 1.4

##Hover and drift vars
var driftDirection: Vector2 = Vector2.RIGHT
var driftTimer: float = 0.0
@export var driftChangeDirMin: float = 0.5
@export var driftChangeDirMax: float = 1.2

##Donut band wander vars
var waitTimer: float = 0.0
var donutTarget: Vector2 = Vector2.ZERO

##Targeting vars
var target: Node2D = null
var attackTarget: Node2D = null
var orbitAngle: float = 0.0

##Sprite vars
var canFlip

func spawnBoss():
	$AnimationPlayer.play("spawn_anim")
	
	await get_tree().create_timer(5.0).timeout
	
	$UI/HealthBar/UIAnim.play("BossBarOverlayAnim")
	$UI/HealthBar/HealthBar.value = hp
	$UI/HealthBar.visible = true
	targetingService.registerEnemy(self)
	
	Globalsettings.inCutscene = false

func _ready():
	PickRandomMoveTarget()

func _process(delta):
	##Movement system
	if Globalsettings.inCutscene == false:
		if !attackInProgress:
			HoverAndDrift(delta)
	#DonutBandWander(delta)

func _on_attack_timer_timeout():
	if Globalsettings.inCutscene == false:
		if !attackInProgress:
			##When the timer runs out, pick a random string from the available attack array
			randomize()
			var randomAttackString = attackArray.pick_random()
			
			##Then match the string to the corrosponding attack
			match randomAttackString:
				"arrowAim":
					arrowAim(10)
				"arrowRain":
					var randomAmount = randi_range(4,12)
					ArrowRain(randomAmount)
				"airSlamAttack":
					airSlamAttack()
				"arrowScatter":
					weakArrowScatter()

func HoverAndDrift(delta: float):
	##When target is null or invalid, find a new target. If none are available, stop moving
	if target == null or not is_instance_valid(target):
		PickRandomMoveTarget()
		if target == null or not is_instance_valid(target):
			velocity = Vector2.ZERO
			move_and_slide()
			return
	
	##Create variables for the center and the distance to the center
	var center = target.global_position
	var toCenter = center - global_position
	
	## Keep at hoverRadius
	var dist = toCenter.length()
	var push: Vector2 = Vector2.ZERO
	
	## Stay within a ring around the player
	if dist > hoverRadius + wanderBand:
		## Too far, move toward center
		push = toCenter.normalized() * moveSpeed
	elif dist < hoverRadius - wanderBand:
		## Too close, move away
		push = -toCenter.normalized() * moveSpeed * 0.7
	else:
		## Wander
		driftTimer -= delta
		if driftTimer <= 0.0:
			driftDirection = Vector2.RIGHT.rotated(randf() * TAU)
			driftTimer = randf_range(driftChangeDirMin, driftChangeDirMax)
		push = driftDirection * moveSpeed * 0.7
	
	velocity = (velocity.lerp(push, 0.15)).limit_length(moveSpeed)
	move_and_slide()

func DonutBandWander(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		PickRandomMoveTarget()
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

func PickRandomMoveTarget():
	##Get meeblings
	var meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##If meeblings are present, choose one as target, if not, set target to null
	if meeblings.size() > 0:
		target = meeblings[randi() % meeblings.size()]
	else:
		target = null

func PickRandomAttackTarget():
	##Get meeblings
	var meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##If meeblings are present, choose one as target, if not, set target to null
	if meeblings.size() > 0:
		attackTarget = meeblings[randi() % meeblings.size()]
	else:
		attackTarget = null

func PickNewDonutPoint():
	if target == null or not is_instance_valid(target):
		return
	var angle = randf() * TAU
	var radius = hoverRadius + randf_range(-wanderBand, wanderBand)
	donutTarget = target.global_position + Vector2(radius, 0).rotated(angle)

func ArrowRain(amountOfArrows: int):
	##Get the crowdSimulation and make a var with its location
	var crowdSimulationPos = get_tree().get_first_node_in_group("CrowdSimulation")
	var arrowLocation = crowdSimulationPos.global_position
	
	##For each arrow to be fired, pick a random offset, spawn an arrow, and make it work
	for i in range(amountOfArrows):
		randomize()
		var randomX = randi_range(-240, 240)
		var randomY = randi_range(-135, 135)
		var arrowFromAboveIn = arrowFromAbove.instantiate()
		crowdSimulationPos.add_child.call_deferred(arrowFromAboveIn)
		arrowFromAboveIn.global_position = Vector2(crowdSimulationPos.global_position.x + randomX ,crowdSimulationPos.global_position.y + randomY)

func arrowAim(damage : int):
	##When target is null or invalid, find a new target. If none are available, stop moving
	if attackTarget == null or not is_instance_valid(attackTarget):
		PickRandomAttackTarget()
		if attackTarget == null or not is_instance_valid(attackTarget):
			return
	
	var markedEffectIn = markedEffect.instantiate()
	attackTarget.add_child(markedEffectIn)
	markedEffectIn.markMeebling(attackTarget)
	markedEffectIn.global_position = attackTarget.global_position
	
	await get_tree().create_timer(1.0).timeout
	
	var arrowIn = arrowBullet.instantiate()
	add_child(arrowIn)
	arrowIn.global_position = global_position
	$Rot.look_at(attackTarget.global_position)
	arrowIn.rotation = $Rot.rotation
	arrowIn.apply_impulse(Vector2(120, 0).rotated($Rot.rotation))

func airSlamAttack():
	##Stop movement when attack starts
	attackInProgress = true
	velocity = Vector2.ZERO
	move_and_slide()
	
	##Play start of attack animation and make boss untargetable
	SetTargetable(false)
	$AnimationPlayer.play("throw_air")
	await $AnimationPlayer.animation_finished
	
	##Spawn in air shadow and child it
	var shadowScene = preload("res://Scenes/BossInAirShadow.tscn")
	shadowInstance = shadowScene.instantiate()
	get_parent().add_child(shadowInstance)
	
	##Get the crowdSimulator, set its position to the center and scale it
	var groupCenter = get_tree().get_first_node_in_group("CrowdSimulation")
	shadowInstance.global_position = groupCenter.global_position
	shadowInstance.scale = Vector2(0.5, 0.5)
	$BossSprite.visible = false
	
	##Attack specific vars
	var airTime = 3
	var followTime = 2.2
	var timer = 0.0
	
	##Follow meeblings for a portion of air time
	while timer < followTime:
		groupCenter = get_tree().get_first_node_in_group("CrowdSimulation")
		shadowInstance.global_position = groupCenter.global_position
		shadowInstance.scale = lerp(Vector2(0.5, 0.5), Vector2(1.5, 1.5), timer / airTime)
		await get_tree().process_frame
		timer += get_process_delta_time()
	
	##Stop following, grow shadow fully for remainder
	while timer < airTime:
		shadowInstance.scale = lerp(Vector2(0.5, 0.5), Vector2(1.5, 1.5), timer / airTime)
		await get_tree().process_frame
		timer += get_process_delta_time()
	
	##Slam down visual parts
	$BossSprite.visible = true
	global_position = shadowInstance.global_position
	$AnimationPlayer.play("slam_down")
	await $AnimationPlayer.animation_finished
	
	##Damage all meeblings in slam radius
	var slamRadius = 56.0
	var meeblings = get_tree().get_nodes_in_group("meeblings")
	for meebling in meeblings:
		if meebling.global_position.distance_to(global_position) < slamRadius:
			meebling.hp -= damage
			meebling.hurt()
	shadowInstance.queue_free()
	
	##Make enemy targetable again
	SetTargetable(true)
	
	##Stun animation
	$AnimationPlayer.play("stunned_after_air")
	await $AnimationPlayer.animation_finished
	
	##Stop attack
	attackInProgress = false
	
func weakArrowScatter(arrowCount: int = 5):
	##Get the crowdSimulator
	var crowdSimulator = get_tree().get_first_node_in_group("CrowdSimulation")
	
	##Make var of boss pos and target pos
	var bossPos = global_position
	var targetPos = crowdSimulator.global_position
	
	##For each arrow to fire
	for i in range(arrowCount):
		##Give it a slight random angle, and set its direction
		var spreadAngle = deg_to_rad(randi_range(-30, 30))
		var baseDirection = (targetPos - bossPos).normalized().angle()
		var arrowDirection = baseDirection + spreadAngle
		
		##Give it a random speed
		var arrowSpeed = randf_range(80.0, 130.0)
		
		##Spawn the arrow, and move it to the meeblings at the random angle
		var arrowInstance = arrowBullet.instantiate()
		get_parent().add_child.call_deferred(arrowInstance)
		arrowInstance.global_position = bossPos
		arrowInstance.rotation = arrowDirection
		arrowInstance.damage = 2
		arrowInstance.apply_impulse(Vector2(arrowSpeed, 0).rotated(arrowDirection))

func SetTargetable(v: bool) -> void:
	isTargetable = v
	hurtBox.monitorable = v
	hurtBox.monitoring = v

func hurt():
	##$EffectsAnim.play("hurt")
	##$Sounds/HurtSound.play()
	$UI/HealthBar/HealthBar.value = hp

func kill():
	##Set status to dead
	##alive = false
	pass
