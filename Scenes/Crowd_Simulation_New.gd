extends CharacterBody2D

##Arrow stats
const arrowSpeed = 60
const acceleration = 0.1
const aimSpeed = 4

##Level vars
var xp = Globalsettings.global_xp
var level = 1
var xpuntilnextlvl = 5

##Ability vars
var spell1ability = 0
var spell2ability = 0
var spell3ability = 0
var spell4ability = 0

var spell1cooldown = 0
var spell2cooldown = 0
var spell3cooldown = 0
var spell4cooldown = 0

var spellnumber = 0
var cooldownspeed = .2

@onready var spellCooldownTimer = $Timers/SpellCooldown

##Preload vars
var meebling = preload("res://Scenes/MeeblingNew.tscn")
var deadSplash = preload("res://Scenes/watersplash.tscn")

var bullet = preload("res://Scenes/bullet_fromcrowd.tscn")
var fireBall = preload("res://Scenes/bullet_fromcrowd_fireball.tscn")
var lightningBolt = preload("res://Scenes/bullet_fromcrowd_thunderbolt.tscn")
var poison = preload("res://Scenes/bullet_fromcrowd_poisonsmoke.tscn")
var frost = preload("res://Scenes/bullet_fromcrowd_snowflake.tscn")

##Array vars
var meeblings
var enemies

##Stat vars
var cooldown = 100
@export var beginCooldown = 100

##Game state vars
var gameOver = false

##===============================##

###Standard functions###

func _ready():
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	
	var arrownr = Globalsettings.global_arrow
	$Mainarrow/Anim.play("arrow" + str(arrownr))
	pass

func _physics_process(_delta):
	##Movement
	movement()
	
	##Attacking
	if cooldown > 0:
			cooldown -= 1
	if cooldown == 0:
		##currentextrabullets = Globalsettings.currentrun_extrabullets
		basicAttack(Globalsettings.currentrun_extrabullets)
		cooldown = beginCooldown - Globalsettings.currentrun_minuscooldown
	
	##Abillities
	castSpelsOnInput()
	
	##Set the closest meebling for the enemies to attack
	if Engine.get_process_frames() % 20 == 0:
		getClosestMeebling()
	
	#EXP system
	expSystem()
	
	##CooldownUI
	spelCooldownUI()
	
	$UI/GameTimerUI.set_text(str(Globalsettings.g_uiminutes) + ":" + str(Globalsettings.g_uisecconds))
	$UI/EnemiesAliveUI.set_text(str(Globalsettings.g_enemiesAlive))

func GameOverCheck():
	##Get meeblings
	meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##If all meeblings are dead, handle gameover
	if meeblings.size() <= 1:
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
	add_child.call_deferred(newMeebling)
	
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

func meeblingSplash(locationToSpawn):
	var splashIn = deadSplash.instantiate()
	splashIn.global_location = locationToSpawn

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

func getClosestEnemy():
	##Make an array with all enemies
	enemies = get_tree().get_nodes_in_group("enemies")
	
	##Set the closest distance, then set it to INF so it is always bigger than the first vallue
	var closestDistance : float = INF
	
	##Loop through all enemies in the array when the array has more than one enemy in it
	if enemies.size() >= 1:
		for enemy in enemies:
			##Calculate the distance
			var distance : float = global_position.distance_squared_to(enemy.global_position)
			##Compare the distance to the the closest distance so far
			if distance < closestDistance:
				##If the distance is closer, set the closest enemy to this enemy and set the closest distance to this distance
				Globalsettings.globalClosestEnemy = enemy
				closestDistance = distance

func getClosestMeebling():
	##Get all meeblings
	meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##Initiallise a closest distance for each quadrant and set it to INF
	var closestDistanceQ1 : float = INF
	var closestDistanceQ2 : float = INF
	var closestDistanceQ3 : float = INF
	var closestDistanceQ4 : float = INF
	
	##Calculate the distances to each quadrant for each meebling and act accordingly
	if meeblings.size() >= 1:
		for meeb in meeblings:
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

func basicAttack(howOftenToAttack):
	##Get the closest enemy
	getClosestEnemy()
	
	##Make an array with all meeblings
	meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##Play sound effect
	$Sounds/Shoot.play()
	
	##Loop through all meeblings
	for meeb in meeblings:
		##Instantiate a new bullet
		var bullet = bullet.instantiate()
		
		##Add the bullet as a child to the meebling
		meeb.add_child.call_deferred(bullet)
		
		##Set the bullet position to the position of the meebling
		bullet.global_position = meeb.global_position
		
		##Get the rotation towards the closest enemy
		var rotation = meeb.rotateTowardsEnemy()
		
		##Move the bullet from the meebling to the closest enemy
		bullet.apply_impulse(Vector2(200, 0).rotated(rotation))
		
		##Set the rotation of the bullet to match the direction of the bullet
		bullet.rotation = rotation
	
	##If there are extra attacks, handle them with a slight delay
	if howOftenToAttack > 0:
		await get_tree().create_timer(0.02).timeout
		basicAttack(howOftenToAttack - 1)

func shootFireBall():
	##Get the closest enemy
	getClosestEnemy()
	
	##Make an array with all meeblings
	meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##Play sound effect
	$Sounds/Bigspell.play()
	
	##Loop through all meeblings
	for meeb in meeblings:
		##Instantiate a new bullet
		var fireBallIn = fireBall.instantiate()
		
		##Add the bullet as a child to the meebling
		meeb.add_child.call_deferred(fireBallIn)
		
		##Set the bullet position to the position of the meebling
		fireBallIn.global_position = meeb.global_position
		
		##Get the rotation towards the closest enemy
		var rotation = meeb.rotateTowardsEnemy()
		
		##Move the bullet from the meebling to the closest enemy
		fireBallIn.apply_impulse(Vector2(140, 0).rotated(rotation))
		
		##Set the rotation of the bullet to match the direction of the bullet
		fireBallIn.rotation = rotation

func shootLightning():
	##Get the closest enemy
	getClosestEnemy()
	
	##Make an array with all meeblings
	meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##Play sound effect
	$Sounds/Bigspell.play()
	
	##Loop through all meeblings
	for meeb in meeblings:
		##Instantiate a new bullet
		var lightningIn = lightningBolt.instantiate()
		
		##Add the bullet as a child to the meebling
		meeb.add_child.call_deferred(lightningIn)
		
		##Set the bullet position to the position of the meebling
		lightningIn.global_position = meeb.global_position
		
		##Get the rotation towards the closest enemy
		var rotation = meeb.rotateTowardsEnemy()
		
		##Move the bullet from the meebling to the closest enemy
		lightningIn.apply_impulse(Vector2(200, 0).rotated(rotation))
		
		##Set the rotation of the bullet to match the direction of the bullet
		lightningIn.rotation = rotation

func shootPoison():
	##Get the closest enemy
	getClosestEnemy()
	
	##Make an array with all meeblings
	meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##Play sound effect
	$Sounds/Bigspell.play()
	
	##Loop through all meeblings
	for meeb in meeblings:
		##Instantiate a new bullet
		var poisonIn = poison.instantiate()
		
		##Add the bullet as a child to the meebling
		meeb.add_child.call_deferred(poisonIn)
		
		##Set the bullet position to the position of the meebling
		poisonIn.global_position = meeb.global_position

func shootFrost():
	##Get the closest enemy
	getClosestEnemy()
	
	##Make an array with all meeblings
	meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##Play sound effect
	$Sounds/Bigspell.play()
	
	##Loop through all meeblings
	for meeb in meeblings:
		##Instantiate a new bullet
		var frostIn = frost.instantiate()
		
		##Add the bullet as a child to the meebling
		meeb.add_child.call_deferred(frostIn)
		
		##Set the bullet position to the position of the meebling
		frostIn.global_position = meeb.global_position
		
		##Get the rotation towards the closest enemy
		var rotation = meeb.rotateTowardsEnemy()
		
		##Move the bullet from the meebling to the closest enemy
		frostIn.apply_impulse(Vector2(100, 0).rotated(rotation))
		
		##Set the rotation of the bullet to match the direction of the bullet
		frostIn.rotation = rotation

func spelCooldownUI():
	if spell1cooldown > 0:
		spell1cooldown -= cooldownspeed
	if spell2cooldown > 0:
		spell2cooldown -= cooldownspeed
	if spell3cooldown > 0:
		spell3cooldown -= cooldownspeed
	if spell4cooldown > 0:
		spell4cooldown -= cooldownspeed
	$UI/Box01/CDB.value = spell1cooldown
	$UI/Box02/CDB.value = spell2cooldown
	$UI/Box03/CDB.value = spell3cooldown
	$UI/Box04/CDB.value = spell4cooldown

func castSpelsOnInput():
	if Input.is_action_just_pressed("spell1") && spell1cooldown <= 0:
			spellnumber = 1
			if Globalsettings.g_spell1 == 0:
				pass
			if Globalsettings.g_spell1 == 1:
				shootFireBall()
				spellCooldownTimer.start()
			if Globalsettings.g_spell1 == 2:
				shootLightning()
				spellCooldownTimer.start()
			if Globalsettings.g_spell1 == 3:
				shootPoison()
				spellCooldownTimer.start()
			if Globalsettings.g_spell1 == 4:
				shootFrost()
				spellCooldownTimer.start()
		
	if Input.is_action_just_pressed("spell2") && spell2cooldown <= 0:
		spellnumber = 2
		if Globalsettings.g_spell2 == 0:
			pass
		if Globalsettings.g_spell2 == 1:
			shootFireBall()
			spellCooldownTimer.start()
		if Globalsettings.g_spell2 == 2:
			shootLightning()
			spellCooldownTimer.start()
		if Globalsettings.g_spell2 == 3:
			shootPoison()
			spellCooldownTimer.start()
		if Globalsettings.g_spell2 == 4:
			shootFrost()
			spellCooldownTimer.start()
	
	if Input.is_action_just_pressed("spell3") && spell3cooldown <= 0:
		spellnumber = 3
		if Globalsettings.g_spell3 == 0:
			pass
		if Globalsettings.g_spell3 == 1:
			shootFireBall()
			spellCooldownTimer.start()
		if Globalsettings.g_spell3 == 2:
			shootLightning()
			spellCooldownTimer.start()
		if Globalsettings.g_spell3 == 3:
			shootPoison()
			spellCooldownTimer.start()
		if Globalsettings.g_spell3 == 4:
			shootFrost()
			spellCooldownTimer.start()
	
	if Input.is_action_just_pressed("spell4") && spell4cooldown <= 0:
		spellnumber = 4
		if Globalsettings.g_spell4 == 0:
			pass
		if Globalsettings.g_spell4 == 1:
			shootFireBall()
			spellCooldownTimer.start()
		if Globalsettings.g_spell4 == 2:
			shootLightning()
			spellCooldownTimer.start()
		if Globalsettings.g_spell4 == 3:
			shootPoison()
			spellCooldownTimer.start()
		if Globalsettings.g_spell4 == 4:
			shootFrost()
			spellCooldownTimer.start()

func _on_spell_cooldown_timeout():
	if spellnumber == 1:
		spell1cooldown = 100
	if spellnumber == 2:
		spell2cooldown = 100
	if spellnumber == 3:
		spell3cooldown = 100
	if spellnumber == 4:
		spell4cooldown = 100

###Attack and spell handling###

##===========================================##

###Leveling system###

func expSystem():
	$UI/LVLbar.value = Globalsettings.global_xp
	$UI/LVLtext.set_text("Level: " + str(level))
	if Globalsettings.global_xp >= xpuntilnextlvl:
		level_up()

func level_up():
	level += 1
	Globalsettings.global_xp -= xpuntilnextlvl
	
	##$LVLup.play()
	
	if level <= 10:
		xpuntilnextlvl += 2
	elif level >= 11 && level <= 30:
		xpuntilnextlvl += 3
	elif level >= 31 && level <= 50:
		xpuntilnextlvl += 4
	elif level >= 51 && level <= 70:
		xpuntilnextlvl += 5
	elif level >= 71 && level <= 90:
		xpuntilnextlvl += 6
	elif level >= 91 && level <= 100:
		xpuntilnextlvl += 7
	elif level >= 101:
		xpuntilnextlvl += 10 + level * 2
	
	$UI/LVLbar.max_value = xpuntilnextlvl
	$UI/LVLbar.value = Globalsettings.global_xp
	$UI/LVLtext.set_text("Level: " + str(level))
	
	$UI/StatHolder.levelUpInit()
	
	get_tree().paused = true

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

###Leveling system###

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
