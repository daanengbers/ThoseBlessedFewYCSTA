extends Node2D

var selectedbutton = 1
var settingselected = 1

var local_musicvol = 50
var local_sfxvol = 50

var canpress = true

var page = 1

@onready var pressanim = $Pressableactions/Anim

func _ready():
	$ButtonAnim.play("default")
	pressanim.play("selectstart")
	Globalsettings.timerrunning = false
	Globalsettings.g_seconds = 0
	Globalsettings.g_uiminutes = 0
	Globalsettings.g_uisecconds = 0
	$HStext.set_text("HIGHEST SCORE: " + str(Globalsettings.highscore_xp))

func _process(_delta):
	if Input.is_action_just_pressed("down") && selectedbutton < 3 && page == 1:
		#pass
		selectotherbutton(2)
	if Input.is_action_just_pressed("up") && selectedbutton > 1 && page == 1:
		selectotherbutton(-2)
	if Input.is_action_pressed("left"):
		if $Settingspage.visible == true:
			if settingselected == 1 && local_musicvol > 0:
				local_musicvol -= 1
				$Settingspage/MusicProgress.value = local_musicvol
	if Input.is_action_pressed("right"):
		if $Settingspage.visible == true:
			if settingselected == 1 && local_musicvol < 100:
				local_musicvol += 1
				$Settingspage/MusicProgress.value = local_musicvol
	
	
	
	if (Input.is_action_just_pressed("spell1") or Input.is_action_just_pressed("spell2") or Input.is_action_just_pressed("spell3") or Input.is_action_just_pressed("spell4")):
		if selectedbutton == 1:
			gotoscene()
		if selectedbutton == 2:
			if page == 2:
				returntomainmenu()
			else:
				$Settingspage.visible = true
				page = 2
		if selectedbutton == 3:
			if $Creditspage.visible == false && canpress == true:
				canpress = false
				$Timers/CanpressTimer.start()
				$Creditspage.visible = true
			if $Creditspage.visible == true && canpress == true:
				canpress = false
				$Timers/CanpressTimer.start()
				$Creditspage.visible = false

func selectotherbutton(plusminus):
	selectedbutton += plusminus
	pressanim.play("RESET")
	if selectedbutton == 1:
		pressanim.play("selectstart")
	if selectedbutton == 2:
		pressanim.play("selectsettings")
	if selectedbutton == 3:
		pressanim.play("selectcredits")
	$Creditspage.visible = false

func returntomainmenu():
	page = 1
	settingselected = 1
	$Settingspage.visible = false
	$Creditspage.visible = false

func gotoscene():
	Globalsettings.resetrun()
	get_tree().change_scene_to_file("res://Scenes/mainscene.tscn")

func _on_canpress_timer_timeout():
	canpress = true
