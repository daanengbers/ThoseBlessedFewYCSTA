extends CharacterBody2D

##Status vars
var hp
@export var maxHp = 10
@export var speed = 30
var internalMaxHp = maxHp + Globalsettings.currentrun_extrahealth
var alive = true
var falling = false
var isIncapacitated = false
var fallingframes = 0

##Randomized vars per meebling
var randomSpeedExtra = 0
var randomOffsetSpace = 0
@export var randomxplus = 0
@export var randomyplus = 0
var randomSprite
var randomShiny

##Arrow vars
@onready var arrow = get_parent()
var arrowPosition = Vector2(0,0)
var distanceToArrow

##animator vars
@onready var meeblingAnimator = $Meebling/Anim

##===============================##

###Standard functions###

func _physics_process(_delta):
	##Movement##
	if alive && !isIncapacitated:
		if Engine.get_process_frames() % 4 == 0:
			getDistanceToArrow()
			$Rot.look_at(arrowPosition)
			movement()
		move_and_slide()
	
	##Colisions
	handleCollisions()

###Standard functions###

##===========================================##

###Setup functions###

func randomizeAndSetup():
	randomize()
	
	##Randomize speed
	randomSpeedExtra = randi()%20 + 10
	
	##Randomize offset from arrow
	if randomxplus == 0:
		randomxplus = randi()%60 - 30
	if randomyplus == 0:
		randomyplus = randi()%40 - 20
	randomOffsetSpace = randi()%8
	
	##Randomize sprite and shininess
	randomSprite = randi()%8
	randomShiny = randi()%4096 + 1
	
	##Setup sprite and shininess 
	if randomShiny == 4096:
		randomSprite = 8
		##spawnSparkle()
	
	##Make movement independent from arrow
	set_as_top_level(true)
	
	##initialise stats
	hp = maxHp
	$Healthbar.max_value = maxHp

func birthEffectsBegin():
	meeblingAnimator = $Meebling/Anim
	meeblingAnimator.play("BirthNew")
	$BirthParticles.emitting = true

func birthEffectsEnd():
	$BirthParticles.emitting = false
	$Meebling.frame = randomSprite
	meeblingAnimator.play("RESET")
	meeblingAnimator.play("BounceNew")
	$Circle.queue_free()

###Setup functions###

##===========================================##

###Movement handling###

func getDistanceToArrow():
	##Get the distance to the arrow by comparing locations
	arrowPosition.x = arrow.position.x + randomxplus
	arrowPosition.y = arrow.position.y + randomyplus
	
	distanceToArrow = abs(global_position - arrowPosition)

func movement():
	##Check if meebling is falling
	if !falling:
		##If distance is big enough, move towards arrow. If not, stop moving
		if distanceToArrow.x > 12 + randomOffsetSpace or distanceToArrow.y > 12 + randomOffsetSpace:
			velocity = Vector2(speed + randomSpeedExtra + Globalsettings.currentrun_extraspeed, 0).rotated($Rot.rotation)
		else:
			velocity.x = 0
			velocity.y = 0
	if falling:
		velocity.y += 20
		fallingframes += 1

func rotateTowardsEnemy():
	##If there is a closest enemy, set the rotation of rot2 to it
	if Globalsettings.globalClosestEnemy != null:
		$Rot2.look_at(Globalsettings.globalClosestEnemy.global_position)
	##Return the rotation for use in attacks
	return $Rot2.rotation

###Movement handling###

##===========================================##

###Death health and hurt handling###

func updateHp():
	##Set maxHP to starting value + globalsettings
	maxHp = maxHp + Globalsettings.currentrun_extrahealth
	
	##Set the UI for the healthbar
	$Healthbar.max_value = maxHp
	$Healthbar.visible = false
	
	##Set the actual hp values
	hp = maxHp

func diefromwater():
	##Spawn splash at meebling location
	arrow.spawnMeeblingSplash(global_position)
	
	##Stop movement
	velocity = Vector2(0,0)
	
	##Set status to dead and hide sprite and shadow
	alive = false
	visible = false
	$Shadow.visible = false
	
	##Play sound effects
	arrow.playSound("Splash")
	arrow.playSound("Break")
	
	##Kill the meebling
	await get_tree().create_timer(0.01).timeout
	arrow.GameOverCheck()
	queue_free()

func hurt():
	if alive == true:
		meeblingAnimator.play("MeeblingLib/RESET")
		meeblingAnimator.play("MeeblingLib/hurt")
		$Healthbar.value = hp
		$Healthbar.visible = true
		arrow.playSound("Hit")

func kill():
	alive = false
	get_parent().playSound("Break")
	arrow.GameOverCheck()
	queue_free()

func fallFromHigh():
	##Set z index to -1 and disable shadow for visuals
	z_index = -1
	$Shadow.visible = false
	
	##Set velocity to 0 to prevent movement
	velocity = Vector2(0,0)
	
	##Play sound effect
	arrow.playSound("Fall")

func checkFallDamage():
	falling = false
	if fallingframes >= 20 && fallingframes < 40:
		hp -= 1
		hurt()
	if fallingframes >= 40 && fallingframes < 60:
		hp -= 2
		hurt()
	if fallingframes >= 60 && fallingframes < 80:
		hp -= 4
		hurt()
	if fallingframes >= 80 && fallingframes < 100:
		hp -= 8
		hurt()
	if fallingframes >= 100 && fallingframes < 120:
		hp -= 16
		hurt()
	if fallingframes >= 120 && fallingframes < 140:
		hp -= 32
		hurt()
	if fallingframes >= 140:
		kill()
	if hp <= 0 && alive == true:
		kill()
	fallingframes = 0

###Death health and hurt handling###

##===========================================##

###Collision handling###

func handleCollisions():
	if $CliffWaterCollider.is_colliding():
			var collider = $CliffWaterCollider.get_collider()
			if alive == true:
				if collider.is_in_group("water_hiddentiles"):
					diefromwater()
				if collider.is_in_group("cliffs_hiddentiles"):
					falling = true
					if fallingframes == 1:
						velocity = Vector2(0,0)
				if collider.is_in_group("highwater_hiddentiles"):
					fallFromHigh()
	else:
		checkFallDamage()


###Collision handling###

##===============================##
