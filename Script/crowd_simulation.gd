extends CharacterBody2D

const SPEED = 60
const AIMSPEED = 4

@onready var aimring = $AimRing

var BIRTH = preload("res://Scenes/meebling_birth.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var arrownr = 1

var aiming = false
var lockedin = false

var spell1ability = 0
var spell2ability = 0
var spell3ability = 0
var spell4ability = 0

var spell1cooldown = 0
var spell2cooldown = 0
var spell3cooldown = 0
var spell4cooldown = 0

var moving_xaxis = 1
var moving_yaxis = 1

var secconds = 0
var minutes = 0

var cooldownspeed = .2

var xp = Globalsettings.global_xp
var level = 1
var xpuntilnextlvl = 5

var crowdm

var sacAmount
var canSac = false
var isSacing = false
var hasSaced = false
var currentSacDoor

var gameover = false

func _ready():
	arrownr = Globalsettings.global_arrow
	$Mainarrow/Anim.play("arrow" + str(arrownr))
	$UI/SelectLevelupscreen/Blackrect/buttonstopress.play("arcade")
	$Mainarrow.flip_h = false
	if arrownr == 8:
		movedownsprite(10)
	if Globalsettings.global_showfps == true:
		$UI/Showfps.visible = true
		$UI/Enemycount.visible = true
		$Timers/CheckFPSTimer.start()
	if Globalsettings.global_controllertype == "Keyboard":
		Keyboard_Formation()
	if Globalsettings.global_controllertype == "Gamepad":
		Gamepad_Formation()

func _physics_process(_delta):
	
	$UI/GameTimerUI.set_text(str(Globalsettings.g_uiminutes) + ":" + str(Globalsettings.g_uisecconds))
	$UI/EnemiesAliveUI.set_text(str(Globalsettings.g_enemiesAlive))
	
	crowdm = get_tree().get_nodes_in_group("crowd_m")
	if crowdm.size() <= 1:
		if gameover == false:
			$Timers/MenuTimer.start()
			gameover = true
			velocity.x = 0
			velocity.y = 0
			$UI/Deathscreen.visible = true
			$UI/Deathscreen/Score.set_text("Score: " + str(Globalsettings.global_total_xp))
	
	# controls
	
	if gameover == false:
		if Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
			if aiming == false:
				velocity.x = (-SPEED - Globalsettings.currentrun_extraspeed) * moving_yaxis
				moving_xaxis = 0.707
			elif aiming == true && $AimRing.position.x > -150:
				$AimRing.position.x -= AIMSPEED
		elif Input.is_action_pressed("right") && !Input.is_action_pressed("left"):
			if aiming == false:
				velocity.x = (SPEED + Globalsettings.currentrun_extraspeed) * moving_yaxis
				moving_xaxis = 0.707
			elif aiming == true && $AimRing.position.x < 150:
				$AimRing.position.x += AIMSPEED
		else:
			velocity.x = 0
			moving_xaxis = 1
		
		if Input.is_action_pressed("up")  && !Input.is_action_pressed("down"):
			if aiming == false:
				velocity.y = (-SPEED - Globalsettings.currentrun_extraspeed) * moving_xaxis
				moving_yaxis = 0.707
			elif aiming == true && $AimRing.position.y > -80:
				$AimRing.position.y -= AIMSPEED * .7
		elif Input.is_action_pressed("down")  && !Input.is_action_pressed("up"):
			if aiming == false:
				velocity.y = (SPEED + Globalsettings.currentrun_extraspeed) * moving_xaxis
				moving_yaxis = 0.707
			elif aiming == true && $AimRing.position.y < 80:
				$AimRing.position.y += AIMSPEED * .7
		else:
			velocity.y = 0
			moving_yaxis = 1
	
	#velocity = Vector2(movespeedx, movespeedy).normalized() * 60
	
	if Input.is_action_just_pressed("aim"):
		$AimRing/Sprite/Anim.play("RESET")
		$AimRing/Sprite/Anim.play("aim")
	if Input.is_action_pressed("aim"):
		aiming = true
		$AimRing.visible = true
		velocity.x = 0
		velocity.y = 0
	if !Input.is_action_pressed("aim"):
		aiming = false
		lockedin = false
		$AimRing.visible = false
		$AimRing.position.x = 0
		$AimRing.position.y = 0
	
	# EXP system
	
	$UI/LVLbar.value = Globalsettings.global_xp
	$UI/LVLtext.set_text("Level: " + str(level))
	if Globalsettings.global_xp >= xpuntilnextlvl:
		level_up()
	
	# Spell cooldown system
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
	
	
	# Stat showcase system
	
	
	#$UI/Spellicon_01/Cooldown.value = spell1cooldown
	
	#velocity.x = SPEED
	
	move_and_slide()

func Keyboard_Formation():
	$UI/Box01.position = Vector2(270,17)
	$UI/Box02.position = Vector2(303,17)
	$UI/Box03.position = Vector2(270,50)
	$UI/Box04.position = Vector2(303,50)
	$UI/Letters.visible = true

func Gamepad_Formation():
	$UI/Box01.position = Vector2(245,35)
	$UI/Box02.position = Vector2(274,17)
	$UI/Box03.position = Vector2(274,54)
	$UI/Box04.position = Vector2(303,35)
	$UI/Buttons.visible = true


func spawnbirth():
	var bi = BIRTH.instantiate()
	get_parent().add_child.call_deferred(bi)
	bi.position = global_position

func movedownsprite(howmuch):
	$Mainarrow.position.y += howmuch

func lock_in():
	lockedin = true

func playrotate():
	$AimRing/Sprite/Anim.play("rotate")

func displayupgrades():
	if Globalsettings.g_spell1 != 0:
		$UI/Box01/UpgradeIcons.frame = Globalsettings.g_spell1 + 4
	if Globalsettings.g_spell2 != 0:
		$UI/Box02/UpgradeIcons.frame = Globalsettings.g_spell2 + 4
	if Globalsettings.g_spell3 != 0:
		$UI/Box03/UpgradeIcons.frame = Globalsettings.g_spell3 + 4
	if Globalsettings.g_spell4 != 0:
		$UI/Box04/UpgradeIcons.frame = Globalsettings.g_spell4 + 4
	$UI/Text_ATKlvl.set_text(str(5 + Globalsettings.currentrun_extraattack))
	$UI/Text_SPDlvl.set_text(str(30 + Globalsettings.currentrun_extraspeed))
	$UI/Text_CDNlvl.set_text(str(-0 + Globalsettings.currentrun_minuscooldown))
	$UI/Text_AMTlvl.set_text(str(1 + Globalsettings.currentrun_extrabullets))
	$UI/Text_HPlvl.set_text(str(10 + Globalsettings.currentrun_extrahealth))
	if Globalsettings.currentrun_minuscooldown >= 80:
		$UI/Text_CDNlvl.modulate = Color(1,.2,.2)
	if Globalsettings.currentrun_minuscooldown == 0:
		$UI/Text_CDNlvl.modulate = Color(1,1,1)

func level_up():
	level += 1
	Globalsettings.global_xp -= xpuntilnextlvl
	
	$LVLup.play()
	
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
	
	$UI/SelectLevelupscreen.spawncards(90)
	$UI/SelectLevelupscreen.spawncards(160)
	$UI/SelectLevelupscreen.spawncards(230)
	
	$UI/SelectLevelupscreen.visible = true
	$UI/SelectLevelupscreen.inmenu = true
	$UI/SelectLevelupscreen.pressed = false
	get_tree().paused = true

func _on_menu_timer_timeout():
	if Globalsettings.highscore_xp < Globalsettings.global_total_xp:
		Globalsettings.highscore_xp = Globalsettings.global_total_xp
	get_tree().change_scene_to_file("res://Scenes/new_titlescreen.tscn")





func _on_check_fps_timer_timeout():
	$Timers/CheckFPSTimer.start()
	$UI/Showfps.set_text("FPS: " + str(Engine.get_frames_per_second()))
	var Enemyamount = get_tree().get_nodes_in_group("enemy_m").size()
	$UI/Enemycount.set_text(str(Enemyamount) + " NMys")




func _on_area_2d_area_entered(SacDoor):
	if SacDoor.is_in_group("Fog"):
		$"../FogEffect/ParallaxLayer/ColorRect/AnimationPlayer".play("FadeIn")
	if SacDoor.is_in_group("SacOption") && isSacing == false:
		isSacing = true
		currentSacDoor = SacDoor
		## This activates the option to sac meeblings
		$UI/SacrificeMeeblingScreen/SacText.set_text("Sacrifice " + str(SacDoor.amountToSac) + " Meeblings
 to open the way?")
		
		sacAmount = SacDoor.amountToSac
		if sacAmount < crowdm.size():
			$UI/SacrificeMeeblingScreen.spawncards(110,1,1)
			$UI/SacrificeMeeblingScreen.spawncards(210,2,2)
			
			$UI/SacrificeMeeblingScreen.visible = true
			$UI/SacrificeMeeblingScreen.inmenu = true
			$UI/SacrificeMeeblingScreen.pressed = false
			
			canSac = true
			
			get_tree().paused = true
			#here we should spawn a yes and no card
		if sacAmount >= crowdm.size():
			$UI/SacrificeMeeblingScreen.spawncards(160,3,3)
			
			$UI/SacrificeMeeblingScreen.visible = true
			$UI/SacrificeMeeblingScreen.inmenu = true
			$UI/SacrificeMeeblingScreen.pressed = false
			
			canSac = false
			get_tree().paused = true
			#here we should spawn a no card
		pass
	pass # Replace with function body.

func _on_area_2d_area_exited(area):
	if area.is_in_group("Fog"):
		$"../FogEffect/ParallaxLayer/ColorRect/AnimationPlayer".play("FadeOut")
	if area.is_in_group("SacOption") && isSacing == true:
		isSacing = false
	pass # Replace with function body.


func _on_unpause_timer_sac_timeout():
	pass # Replace with function body.
	
func SacMeeblings():
	currentSacDoor.isCleared = true
	hasSaced = true
	if sacAmount == 1:
		crowdm[0].kill()
	if sacAmount == 2:
		crowdm[0].kill()
		crowdm[1].kill()
	if sacAmount == 3:
		crowdm[0].kill()
		crowdm[1].kill()
		crowdm[2].kill()
	if sacAmount == 4:
		crowdm[0].kill()
		crowdm[1].kill()
		crowdm[2].kill()
		crowdm[3].kill()
	if sacAmount == 5:
		crowdm[0].kill()
		crowdm[1].kill()
		crowdm[2].kill()
		crowdm[3].kill()
		crowdm[4].kill()
	pass
	

