extends CharacterBody2D

const SPEED = 80
const AIMSPEED = 4

@onready var aimring = $AimRing

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

var movespeedx = 0
var movespeedy = 0

var secconds = 0
var minutes = 0

var cooldownspeed = .2

var xp = Globalsettings.global_xp
var level = 1
var xpuntilnextlvl = 5

var crowdm

var gameover = false

func _ready():
	arrownr = Globalsettings.global_arrow
	$Mainarrow/Anim.play("arrow" + str(arrownr))
	$UI/SelectLevelupscreen/Blackrect/buttonstopress.play("default")
	$Mainarrow.flip_h = false
	if arrownr == 8:
		movedownsprite(10)

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
				movespeedx = -SPEED - Globalsettings.currentrun_extraspeed
			elif aiming == true && $AimRing.position.x > -150:
				$AimRing.position.x -= AIMSPEED
		elif Input.is_action_pressed("right") && !Input.is_action_pressed("left"):
			if aiming == false:
				movespeedx = SPEED + Globalsettings.currentrun_extraspeed
			elif aiming == true && $AimRing.position.x < 150:
				$AimRing.position.x += AIMSPEED
		else:
			movespeedx = 0
		
		if Input.is_action_pressed("up")  && !Input.is_action_pressed("down"):
			if aiming == false:
				movespeedy = -SPEED - Globalsettings.currentrun_extraspeed
			elif aiming == true && $AimRing.position.y > -80:
				$AimRing.position.y -= AIMSPEED * .7
		elif Input.is_action_pressed("down")  && !Input.is_action_pressed("up"):
			if aiming == false:
				movespeedy = SPEED + Globalsettings.currentrun_extraspeed
			elif aiming == true && $AimRing.position.y < 80:
				$AimRing.position.y += AIMSPEED * .7
		else:
			movespeedy = 0
	
	velocity = Vector2(movespeedx, movespeedy).normalized() * 60
	
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



