extends Node2D

var selectedbutton = 1
var settingselected = 1

var page = 1

@onready var pressanim = $Pressableactions/Anim

func _ready():
	$ButtonAnim.play("default")
	pressanim.play("selectstart")
	Globalsettings.timerrunning = false
	Globalsettings.g_seconds = 0
	Globalsettings.g_uiminutes = 0
	Globalsettings.g_uisecconds = 0

func _process(_delta):
	if Input.is_action_just_pressed("down") && selectedbutton < 3 && page == 1:
		selectotherbutton(1)
	if Input.is_action_just_pressed("up") && selectedbutton > 1 && page == 1:
		selectotherbutton(-1)
	
	if (Input.is_action_just_pressed("spell1") or Input.is_action_just_pressed("spell2") or Input.is_action_just_pressed("spell3") or Input.is_action_just_pressed("spell4")):
		if selectedbutton == 1:
			gotoscene()
		if selectedbutton == 2:
			$Settingspage.visible = true
			page = 2
		if selectedbutton == 3:
			$Creditspage.visible = true

func selectotherbutton(plusminus):
	selectedbutton += plusminus
	if selectedbutton == 1:
		pressanim.play("selectstart")
	if selectedbutton == 2:
		pressanim.play("selectsettings")
	if selectedbutton == 3:
		pressanim.play("selectcredits")
	$Creditspage.visible = false

func gotoscene():
	Globalsettings.resetrun()
	get_tree().change_scene_to_file("res://Scenes/mainscene.tscn")
