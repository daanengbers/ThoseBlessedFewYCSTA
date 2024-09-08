extends Node2D

var pressed_nextscene = false
var controllertype = ""
var nextscene = 1

var menuselected = 0

var menu_main_selected = 1
var arrowselected = 1
var settingselected = 1

var local_sfx_volume = 100
var local_music_volume = 100



func _ready():
	$Startoptions/Selecticon/Iconanim.play("flame")
	$Blackscreen/FadeAnim.play("fadein")
	$Startrun/Startruntext02.set_text("PREVIOUS SCORE: " + str(0))
	$Startrun/Startruntext03.set_text("HIGHEST SCORE: " + str(Globalsettings.highscore_xp))
	arrowselected = Globalsettings.global_arrow
	change_arrow()
	$Customize/Arrowskin/Skinplayer.play("arrow" + str(arrowselected))
	if Globalsettings.global_fullscreen == true:
		$Settings/Setting05.set_text("Full Screen: ON >")
	elif Globalsettings.global_fullscreen == false:
		$Settings/Setting05.set_text("Full Screen: < OFF")

func _process(_delta):
	
	if Input.is_action_just_pressed("down"):
		if menuselected == 0 && menu_main_selected < 6:
			changemenuselect_main(1)
		if menuselected == 2 && settingselected < 5:
			settingselected += 1
			change_setting()
	if Input.is_action_just_pressed("up"):
		if menuselected == 0 && menu_main_selected > 1:
			changemenuselect_main(-1)
		if menuselected == 2 && settingselected > 1:
			settingselected -= 1
			change_setting()
	
	if Input.is_action_just_pressed("left"):
		if menuselected == 0 && menu_main_selected == 3:
			if arrowselected > 1:
				arrowselected -= 1
				$Customize/Arrowskin/Skinplayer.play("arrow" + str(arrowselected))
				change_arrow()
		if menuselected == 2 && settingselected == 4:
			if Globalsettings.global_fullscreen == false:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				Globalsettings.global_fullscreen = true
				$Settings/Setting05.set_text("Full Screen: ON >")
	if Input.is_action_just_pressed("right"):
		if menuselected == 0 && menu_main_selected == 3:
			if arrowselected < 8:
				arrowselected += 1
				$Customize/Arrowskin/Skinplayer.play("arrow" + str(arrowselected))
				change_arrow()
		if menuselected == 2 && settingselected == 4:
			if Globalsettings.global_fullscreen == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				Globalsettings.global_fullscreen = false
				$Settings/Setting05.set_text("Full Screen: < OFF")
	
	
	
	if Input.is_action_just_pressed("any_keyboard"):
		Globalsettings.global_controllertype = "Keyboard"
		$Startrun/Startruntext04.set_text("Keyboard detected")
		$Startrun/CE_keyboard.visible = true
		$Startrun/CE_Controller.visible = false
	if Input.is_action_just_pressed("any_gamepad"):
		Globalsettings.global_controllertype = "Gamepad"
		$Startrun/Startruntext04.set_text("Controller detected")
		$Startrun/CE_keyboard.visible = false
		$Startrun/CE_Controller.visible = true
	
	if Input.is_action_just_pressed("spell1") or Input.is_action_just_pressed("spell2") or Input.is_action_just_pressed("spell3") or Input.is_action_just_pressed("spell4") or Input.is_action_just_pressed("enter"):
		if menu_main_selected == 1:
			Go_to_other_scene(1)
		if menu_main_selected == 2:
			Go_to_other_scene(2)
		if menu_main_selected == 4 && menuselected == 0:
			go_to_settings()
		if menu_main_selected == 6:
			OS.shell_open("https://forms.gle/8HK2TkKNP3kmGMYR8")
		if menuselected == 2 && settingselected == 5:
			back_to_mainmenu()

func changemenuselect_main(add_move):
	menu_main_selected += add_move
	$Startoptions/Selecticon.position.x = 12
	if menu_main_selected == 1:
		$Startoptions/Selecticon.position.y = 72
		$Startrun.visible = true
		$Tutorial.visible = false
	if menu_main_selected == 2:
		$Startoptions/Selecticon.position.y = 87
		$Startrun.visible = false
		$Tutorial.visible = true
		$Customize.visible = false
	if menu_main_selected == 3:
		$Startoptions/Selecticon.position.y = 102
		$Tutorial.visible =  false
		$Customize.visible = true
		$Settings.visible = false
	if menu_main_selected == 4:
		$Startoptions/Selecticon.position.y = 117
		$Customize.visible = false
		$Settings.visible = true
		$Credits.visible = false
	if menu_main_selected == 5:
		$Startoptions/Selecticon.position.y = 132
		$Settings.visible = false
		$Credits.visible = true
		$Feedback.visible = false
	if menu_main_selected == 6:
		$Startoptions/Selecticon.position.y = 147
		$Credits.visible = false
		$Feedback.visible = true

func change_arrow():
	$Customize/Arrowskin.flip_h = false
	if arrowselected == 1:
		$Customize/Customizetext02.set_text("Red Arrow")
	if arrowselected == 2:
		$Customize/Customizetext02.set_text("Classic Arrow")
	if arrowselected == 3:
		$Customize/Customizetext02.set_text("Pointy Finger")
	if arrowselected == 4:
		$Customize/Customizetext02.set_text("Sketchy Arrow")
	if arrowselected == 5:
		$Customize/Customizetext02.set_text("Knight's Blade")
	if arrowselected == 6:
		$Customize/Customizetext02.set_text("XP Arrow")
	if arrowselected == 7:
		$Customize/Customizetext02.set_text("moo")
	if arrowselected == 8:
		$Customize/Customizetext02.set_text("quack")

func go_to_settings():
	menuselected = 2
	$Startoptions/Selecticon.position.x = 172
	settingselected = 1
	change_setting()

func back_to_mainmenu():
	menuselected = 0
	settingselected = 1
	changemenuselect_main(0)

func change_setting():
	if settingselected == 1:
		$Startoptions/Selecticon.position.y = 76
	if settingselected == 2:
		$Startoptions/Selecticon.position.y = 96
	if settingselected == 3:
		$Startoptions/Selecticon.position.y = 117
	if settingselected == 4:
		$Startoptions/Selecticon.position.y = 129
	if settingselected == 5: # Back option
		$Startoptions/Selecticon.position.y = 151
	
	

func Go_to_other_scene(scenenr):
	menuselected = -1
	nextscene = scenenr
	$Blackscreen/FadeAnim.play("fadeout")

func enter_next_scene():
	if nextscene == 1:
		Globalsettings.global_arrow = arrowselected
		Globalsettings.resetrun()
		get_tree().change_scene_to_file("res://Scenes/mainscene.tscn")
	if nextscene == 2:
		get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
