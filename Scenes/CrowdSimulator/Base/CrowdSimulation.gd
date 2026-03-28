extends CharacterBody2D

##Services
@onready var targetingService = $TargetingService
@onready var attackingService = $AttackingService
@onready var AbilityService = $AbilityService

##Arrow stats
const arrowSpeed : float = 60
const acceleration : float = 0.1
const aimSpeed : float = 4

##Preload vars
var meebling = GameResources.meeblingScene
var meeblingParent: Node2D 
var deadSplash = GameResources.splashEffectScene

var bullet = GameResources.baseBulletScene
var fireBall = GameResources.fireBallScene
var lightningBolt = GameResources.lightningBoltScene
var poison = GameResources.poisonScene
var frost = GameResources.frostScene

##Stat vars
var cooldown = 100
@export var beginCooldown = 100

@export var beginCooldownSeconds: float = 1.0
var basicAttackCooldown: float = 0.0

##Game state vars
var gameOver = false

##===============================##

###Standard functions###

func _ready():
	meeblingParent = get_tree().get_first_node_in_group("MeeblingParentNode")
	
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	
	var arrownr = Globalsettings.global_arrow
	$Mainarrow/Anim.play("arrow" + str(arrownr))
	pass

func _physics_process(delta: float) -> void:
	if Globalsettings.inCutscene == false:
		##Movement
		movement()
		
		##Attacking
		basicAttackCooldown = max(0.0, basicAttackCooldown - delta)
		if basicAttackCooldown <= 0.0:
			basicAttack(Globalsettings.currentrun_extrabullets)
			basicAttackCooldown = max(0.05, beginCooldownSeconds - Globalsettings.currentrun_minuscooldown * 0.01)
		
		##Abillities
		AbilityService.HandleAbilityInput()
		
		##Set the closest meebling for the enemies to attack
		if Engine.get_process_frames() % 20 == 0:
			getClosestMeebling()
		
	
	##CooldownUI
	UpdateAbilityUI()
	
	$UI/GameTimerUI.set_text(str(Globalsettings.g_uiminutes) + ":" + str(Globalsettings.g_uisecconds))
	$UI/EnemiesAliveUI.set_text(str(Globalsettings.g_enemiesAlive))

func GameOverCheck():
	##If all meeblings are dead, handle gameover
	if targetingService.meeblings.size() == 0:
		if gameOver == false:
			gameOver = true
			velocity.x = 0
			velocity.y = 0
			$UI/Deathscreen.visible = true
			$UI/Deathscreen/Score.set_text("Score: " + str(Globalsettings.global_total_xp))
			
			##Go back to main menu after 6 secconds
			await get_tree().create_timer(6.0).timeout
			if Globalsettings.highscore_xp < Globalsettings.global_total_xp:
				Globalsettings.highscore_xp = Globalsettings.global_total_xp
			get_tree().change_scene_to_file("res://Scenes/new_titlescreen.tscn")

###Standard functions###

##===========================================##

###Movement handling###

func get_Input():
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	return Vector2(horizontal, vertical)

func movement():
	var direction = get_Input()
	velocity = velocity.lerp(direction.normalized() * (arrowSpeed + Globalsettings.currentrun_extraspeed), acceleration ) ##+ Globalsettings.currentrun_extraspeed
	move_and_slide()

###Movement handling###

##===========================================##

###Meebling functions###

func birthMeebling(spawnPos):
	##Instantiate meebling
	var newMeebling = meebling.instantiate()
	
	##Add the instantiated meebling as a child to the arrow
	meeblingParent.add_child.call_deferred(newMeebling)
	
	##Run the randomiser and setup for the meebling
	newMeebling.randomizeAndSetup()
	
	##Spawn the meebling at the correct location
	if(spawnPos == global_position):
		newMeebling.position.x = spawnPos.x + newMeebling.randomxplus
		newMeebling.position.y = spawnPos.y + newMeebling.randomyplus
	else:
		newMeebling.position = spawnPos
	
	##Play birth animation
	newMeebling.birthEffectsBegin()
	
	##Wait till animation is done
	await get_tree().create_timer(1.0).timeout
	
	##End birth animation
	newMeebling.birthEffectsEnd()

func meeblingDied():
	##When a meebling dies, check the amount of meeblings left and act accordingly
	pass

func sacMeeblings(meebAmountToSac):
	##Sac the specified amount of meeblings
	pass

func spawnMeeblingSplash(locationToSpawn):
	var splashIn = deadSplash.instantiate()
	add_child.call_deferred(splashIn)
	splashIn.global_position = locationToSpawn

###Meebling functions###

##===========================================##

###Get closest entities###
func getClosestMeebling():
	##Initiallise a closest distance for each quadrant and set it to INF
	var closestDistanceQ1 : float = INF
	var closestDistanceQ2 : float = INF
	var closestDistanceQ3 : float = INF
	var closestDistanceQ4 : float = INF
	
	##Calculate the distances to each quadrant for each meebling and act accordingly
	if targetingService.meeblings.size() >= 1:
		for meeb in targetingService.meeblings:
			var distanceQ1 : float = $QuadrantSystem/Q1.global_position.distance_squared_to(meeb.global_position)
			var distanceQ2 : float = $QuadrantSystem/Q2.global_position.distance_squared_to(meeb.global_position)
			var distanceQ3 : float = $QuadrantSystem/Q3.global_position.distance_squared_to(meeb.global_position)
			var distanceQ4 : float = $QuadrantSystem/Q4.global_position.distance_squared_to(meeb.global_position)
			if distanceQ1 < closestDistanceQ1: 
				Globalsettings.globalClosestMeeblingQ1 = meeb
				closestDistanceQ1 = distanceQ1
			if distanceQ2 < closestDistanceQ2: 
				Globalsettings.globalClosestMeeblingQ2 = meeb
				closestDistanceQ2 = distanceQ2
			if distanceQ3 < closestDistanceQ3: 
				Globalsettings.globalClosestMeeblingQ3 = meeb
				closestDistanceQ3 = distanceQ3
			if distanceQ4 < closestDistanceQ4: 
				Globalsettings.globalClosestMeeblingQ4 = meeb
				closestDistanceQ4 = distanceQ4

###Get closest entities###

##===========================================##

###Attack and spell handling###

func basicAttack(extraAttacks: int) -> void:
	for i in range(extraAttacks + 1):
		attackingService.fireProjectile(bullet, attackingService.bulletImpulse, false)
		if i < extraAttacks:
			await get_tree().create_timer(0.02).timeout

func UpdateAbilityUI() -> void:
	$UI/AbilityBoxes/Box01/CDB.max_value = AbilityService.GetSlotCooldownMax(1)
	$UI/AbilityBoxes/Box01/CDB.value = AbilityService.GetSlotCooldown(1)
	$UI/AbilityBoxes/Box02/CDB.max_value = AbilityService.GetSlotCooldownMax(2)
	$UI/AbilityBoxes/Box02/CDB.value = AbilityService.GetSlotCooldown(2)
	$UI/AbilityBoxes/Box03/CDB.max_value = AbilityService.GetSlotCooldownMax(3)
	$UI/AbilityBoxes/Box03/CDB.value = AbilityService.GetSlotCooldown(3)
	$UI/AbilityBoxes/Box04/CDB.max_value = AbilityService.GetSlotCooldownMax(4)
	$UI/AbilityBoxes/Box04/CDB.value = AbilityService.GetSlotCooldown(4)

###Attack and spell handling###

##===========================================##

func displayupgrades():
	if Globalsettings.g_spell1 != 0:
		$UI/Box01/UpgradeIcons.frame = Globalsettings.g_spell1 + 4
	if Globalsettings.g_spell2 != 0:
		$UI/Box02/UpgradeIcons.frame = Globalsettings.g_spell2 + 4
	if Globalsettings.g_spell3 != 0:
		$UI/Box03/UpgradeIcons.frame = Globalsettings.g_spell3 + 4
	if Globalsettings.g_spell4 != 0:
		$UI/Box04/UpgradeIcons.frame = Globalsettings.g_spell4 + 4
	$UI/PauseMenu/StatSheet/Text_ATKlvl.set_text(str(5 + Globalsettings.currentrun_extraattack))
	$UI/PauseMenu/StatSheet/Text_SPDlvl.set_text(str(30 + Globalsettings.currentrun_extraspeed))
	$UI/PauseMenu/StatSheet/Text_CDNlvl.set_text(str(-0 + Globalsettings.currentrun_minuscooldown))
	$UI/PauseMenu/StatSheet/Text_AMTlvl.set_text(str(1 + Globalsettings.currentrun_extrabullets))
	$UI/PauseMenu/StatSheet/Text_HPlvl.set_text(str(10 + Globalsettings.currentrun_extrahealth))
	if Globalsettings.currentrun_minuscooldown >= 80:
		$UI/PauseMenu/StatSheet/Text_CDNlvl.modulate = Color(1,.2,.2)
	if Globalsettings.currentrun_minuscooldown == 0:
		$UI/PauseMenu/StatSheet/Text_CDNlvl.modulate = Color(1,1,1)

##===========================================##

###Sound effects###

func playSound(soundToPlay):
	match soundToPlay:
		"Hit":
			$Sounds/Hit.play()
		"Break":
			$Sounds/Break.play()
		"Splash":
			$Sounds/SoundsSplash.play()
		"Fall":
			$Sounds/Fall.play()

###Sound effects###

##===========================================##

###Colision handling###

func _on_crowd_simulator_area_area_entered(area):
	pass # Replace with function body.


func _on_crowd_simulator_area_area_exited(area):
	pass # Replace with function body.

###Colision handling###

##===============================##
