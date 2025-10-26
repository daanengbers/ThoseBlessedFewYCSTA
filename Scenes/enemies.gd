extends CharacterBody2D

##Stats
@export var enemyType = "Eyeball"
@export var spawnMeebOnDeath = false
@export var hp = 40
@export var speed = 20
@export var baseXpDropped = 1
var randomSpeedExtra

##Status vars
var alive = true

##Animator vars
@onready var animator = $Icon/Anim
@export var canflip = false

##Targeting vars
var quadrant = 1
var distanceToMeebling
var meeblingToDamage
var withinReach = false

##Enemy specific stats
var startedExploding = false

##Preload vars
var xpDrop = preload("res://Scenes/XPEffect.tscn")
var explosion = preload("res://Scenes/bloodexplosion.tscn")

func _ready():
	randomize()
	
	##Set random extra speed
	randomSpeedExtra = randi()%10
	
	##Set default values
	animator.play("bounce")
	$EffectsAnim.play("default")
	$Icon/Coloranim.play("fadein")
	$Healthbar.max_value = hp
	$Healthbar.value = hp
	
	set_as_top_level(true)

func _process(delta):
	##Handle movement every 4 secconds
	if Engine.get_process_frames() % 4 == 0:
		rotateTowardsClosestMeebling()
	
	##Keep move and slide here to make it independent of frames
	move_and_slide()

func rotateTowardsClosestMeebling():
	##Rotate towards the closest enemy in the assigned quadrant an calculate the distance
	match quadrant:
		1:
			if is_instance_valid(Globalsettings.globalClosestMeeblingQ1):
				$Rot.look_at(Globalsettings.globalClosestMeeblingQ1.global_position)
				distanceToMeebling = abs(global_position - Globalsettings.globalClosestMeeblingQ1.global_position)
				meeblingToDamage = Globalsettings.globalClosestMeeblingQ1
		2:
			if is_instance_valid(Globalsettings.globalClosestMeeblingQ2):
				$Rot.look_at(Globalsettings.globalClosestMeeblingQ2.global_position)
				distanceToMeebling = abs(global_position - Globalsettings.globalClosestMeeblingQ2.global_position)
				meeblingToDamage = Globalsettings.globalClosestMeeblingQ2
		3:
			if is_instance_valid(Globalsettings.globalClosestMeeblingQ3):
				$Rot.look_at(Globalsettings.globalClosestMeeblingQ3.global_position)
				distanceToMeebling = abs(global_position - Globalsettings.globalClosestMeeblingQ3.global_position)
				meeblingToDamage = Globalsettings.globalClosestMeeblingQ3
		4:
			if is_instance_valid(Globalsettings.globalClosestMeeblingQ4):
				$Rot.look_at(Globalsettings.globalClosestMeeblingQ4.global_position)
				distanceToMeebling = abs(global_position - Globalsettings.globalClosestMeeblingQ4.global_position)
				meeblingToDamage = Globalsettings.globalClosestMeeblingQ4
	##Check if the distance to the meebling is great enough to keep moving and if the enemy is able to move
	if distanceToMeebling != null:
		if (distanceToMeebling.x > 20 or distanceToMeebling.y > 20) && startedExploding == false:
			velocity = Vector2(speed + randomSpeedExtra, 0).rotated($Rot.rotation)
			withinReach = false
		else:
			velocity.x = 0
			velocity.y = 0
			withinReach = true
	
	##Flip sprite if possible
	if canflip == true:
				if velocity.x > 0:
					$Icon.flip_h = true
				else:
					$Icon.flip_h = false
					
	if withinReach:
		match enemyType:
			"Exploding":
				if !startedExploding:
					explode()
			"NormalAttack":
				if meeblingToDamage != null:
					meeblingToDamage.hp -= 1
					meeblingToDamage.hurt()
					if meeblingToDamage.hp <= 0:
						meeblingToDamage.kill()
				velocity = Vector2(0,0)
				

func changeQuadrant(quadrantToChangeTo):
	quadrant = quadrantToChangeTo

func explode():
	##Set the bool so it can't explode again
	startedExploding = true
	
	##Play the explosion start animation
	animator.play("explodestartup")
	await get_tree().create_timer(1.0).timeout
	
	##Instantiate the explosion and add it as a child to the arrow
	var explosionIn = explosion.instantiate()
	var arrow =  get_tree().get_first_node_in_group("CrowdSimulation")
	arrow.add_child.call_deferred(explosionIn)
	explosionIn.position = global_position
	
	##kill the eyeball
	kill()

func hurt():
	$EffectsAnim.play("hurt")
	$Sounds/HurtSound.play()
	$Healthbar.visible = true
	$Healthbar.value = hp

func kill():
	##Set status to dead
	alive = false
	
	##increase global xp by base amount and scaled amount
	Globalsettings.global_xp += baseXpDropped ##Add scaled amount##!!
	spawnXpEffect()
	
	if spawnMeebOnDeath:
		var arrow = get_tree().get_first_node_in_group("CrowdSimulation")
		arrow.birthMeebling(global_position)
		
	queue_free()

func _on_hur_tbox_enemy_area_entered(area):
	if area.is_in_group("Q1"):
		quadrant = 1
	if area.is_in_group("Q2"):
		quadrant = 2
	if area.is_in_group("Q3"):
		quadrant = 3
	if area.is_in_group("Q4"):
		quadrant = 4

func spawnXpEffect():
	$Icon.visible = false
	var xpEffect = xpDrop.instantiate()
	var arrow =  get_tree().get_first_node_in_group("CrowdSimulation")
	arrow.add_child.call_deferred(xpEffect)
	xpEffect.global_position = global_position
	xpEffect.playAnimAndKill()
