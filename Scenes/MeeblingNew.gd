extends CharacterBody2D

const speed = 30

##Status vars
var hp
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

var MAX_HP = 10 + Globalsettings.currentrun_extrahealth

@onready var arrow = get_parent()
var arrowPosition = Vector2(0,0)
var distanceToArrow

@onready var meeblingAnimator = $Meebling/Anim

func _ready():
	##Randomise sprite, Shininess and stats and setup the meebling
	##randomizeAndSetup()
	pass

func _physics_process(_delta):
	##Movement##
	if alive && !isIncapacitated:
		getDistanceToArrow()
		$Rot.look_at(arrowPosition)
		movement()

func getDistanceToArrow():
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
	move_and_slide()

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

func birthEffectsBegin():
	meeblingAnimator = $Meebling/Anim
	meeblingAnimator.play("BirthNew")
	$BirthParticles.emitting = true

func birthEffectsEnd():
	$BirthParticles.emitting = false
	$Meebling.frame = randomSprite
	meeblingAnimator.play("RESET")
	meeblingAnimator.play("BounceNew")

func rotateTowardsEnemy():
	if Globalsettings.globalClosestEnemy != null:
		$Rot2.look_at(Globalsettings.globalClosestEnemy.global_position)
	return $Rot2.rotation
