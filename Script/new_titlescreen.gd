extends Node2D

# Script for title screen after the game-jam.
# Weenter Approved (Great Cleanup, 9-9-24)

var pressed_nextscene = false
var controllertype = ""
var nextscene = 1

var menuselected = 0
var canpress = false

var menu_main_selected = 1
var arrowselected = 1
var settingselected = 1

var local_sfx_volume = 100
var local_music_volume = 100

func _ready():
	
	# Set up default animations
	
	$Startoptions/Selecticon/Iconanim.play("flame")
	$Blackscreen/FadeAnim.play("fadein")
	
	# Display score
	
	$Startrun/Startruntext02.set_text("PREVIOUS SCORE: " + str(0))
	$Startrun/Startruntext03.set_text("HIGHEST SCORE: " + str(Globalsettings.highscore_xp))
	
	# Set local variables to global variables
	
	# ----- Set music to main theme
	Globalsettings.bossfight_active = false
	Globalsettings.setmusic()
	Globalsettings.globalmusic = 1
	
	# ----- Set arrow to global arrow
	arrowselected = Globalsettings.global_arrow
	$Customize/Arrowskin/Skinplayer.play("arrow" + str(arrowselected))
	changeArrow()
	
	# ----- Set settings/settings display to global settings
	if Globalsettings.global_showfps == true:
		$Settings/Setting04.set_text("Show FPS: ON >")
	elif Globalsettings.global_showfps == false:
		$Settings/Setting04.set_text("Show FPS: < OFF")
	if Globalsettings.global_fullscreen == true:
		$Settings/Setting05.set_text("Full Screen: ON >")
	elif Globalsettings.global_fullscreen == false:
		$Settings/Setting05.set_text("Full Screen: < OFF")
	$Settings/SFX_bar.value = Globalsettings.global_SFXvol
	$Settings/Music_bar.value = Globalsettings.global_Musicvol

func _process(_delta):
	
	# Up and down inputs
	
	if Input.is_action_just_pressed("down") && canpress == true:
		if menuselected == 0 && menu_main_selected < 6:
			changeMenuSelectMain(1)
			$Sounds/move.play()
		if menuselected == 2 && settingselected < 5:
			settingselected += 1
			changeSetting()
			$Sounds/move.play()
	if Input.is_action_just_pressed("up"):
		if menuselected == 0 && menu_main_selected > 1:
			changeMenuSelectMain(-1)
			$Sounds/move.play()
		if menuselected == 2 && settingselected > 1:
			settingselected -= 1
			changeSetting()
			$Sounds/move.play()
	
	# Left and right inputs
	
	if Input.is_action_just_pressed("left"):
		if menuselected == 0 && menu_main_selected == 3:
			if arrowselected > 1:
				arrowselected -= 1
				$Customize/Arrowskin/Skinplayer.play("arrow" + str(arrowselected))
				changeArrow()
				$Sounds/move.play()
		if menuselected == 2 && settingselected == 1 && Globalsettings.global_SFXvol > 0:
			Globalsettings.global_SFXvol -= 0.05
			$Settings/SFX_bar.value = Globalsettings.global_SFXvol
			$Sounds/move.play()
		if menuselected == 2 && settingselected == 2 && Globalsettings.global_Musicvol > 0:
			Globalsettings.global_Musicvol -= 0.05
			$Settings/Music_bar.value = Globalsettings.global_Musicvol
			$Sounds/move.play()
		if menuselected == 2 && settingselected == 3:
			if Globalsettings.global_showfps == false:
				Globalsettings.global_showfps = true
				$Settings/Setting04.set_text("Show FPS: ON >")
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
				changeArrow()
				$Sounds/move.play()
		if menuselected == 2 && settingselected == 1 && Globalsettings.global_SFXvol < 1:
			Globalsettings.global_SFXvol += 0.05
			$Settings/SFX_bar.value = Globalsettings.global_SFXvol
			$Sounds/move.play()
		if menuselected == 2 && settingselected == 2 && Globalsettings.global_Musicvol < 1:
			Globalsettings.global_Musicvol += 0.05
			$Settings/Music_bar.value = Globalsettings.global_Musicvol
			$Sounds/move.play()
		if menuselected == 2 && settingselected == 3:
			if Globalsettings.global_showfps == true:
				Globalsettings.global_showfps = false
				$Settings/Setting04.set_text("Show FPS: < OFF>")
		if menuselected == 2 && settingselected == 4:
			if Globalsettings.global_fullscreen == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				Globalsettings.global_fullscreen = false
				$Settings/Setting05.set_text("Full Screen: < OFF")
	
	# Check controller type and change settings accordingly
	
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
	
	# Enter inputs
	
	if (Input.is_action_just_pressed("spell1") or Input.is_action_just_pressed("spell2") or Input.is_action_just_pressed("spell3") or Input.is_action_just_pressed("spell4") or Input.is_action_just_pressed("enter")) && canpress == true:
		if menu_main_selected == 1:
			goToOtherScene(1)
			$Sounds/select.play()
		if menu_main_selected == 2:
			goToOtherScene(2)
			$Sounds/select.play()
		if menu_main_selected == 4 && menuselected == 0:
			goToSettings()
			$Sounds/select.play()
		if menu_main_selected == 6:
			$Feedback/Feedback02.set_text("A tab with a feedback questionaire should have opened in your browser. Please check your browser.")
			OS.shell_open("https://forms.gle/8HK2TkKNP3kmGMYR8")
			$Sounds/select.play()
		if menuselected == 2 && settingselected == 5:
			backToMainMenu()
			$Sounds/back.play()

# Functions -----

func changeMenuSelectMain(add_move):
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

func changeArrow():
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

func goToSettings():
	menuselected = 2
	$Startoptions/Selecticon.position.x = 172
	settingselected = 1
	changeSetting()

func backToMainMenu():
	menuselected = 0
	settingselected = 1
	changeMenuSelectMain(0)

func changeSetting():
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

func goToOtherScene(scenenr):
	canpress = false
	menuselected = -1
	nextscene = scenenr
	$Blackscreen/FadeAnim.play("fadeout")

func enterNextScene():
	canpress = false
	if nextscene == 1:
		Globalsettings.global_arrow = arrowselected
		Globalsettings.resetrun()
		get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	if nextscene == 2:
		get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")

# Signals -----

func _on_sfx_bar_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	Globalsettings.global_SFXvol = value

func _on_music_bar_value_changed(value):
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	Globalsettings.global_Musicvol = value

func _on_canpress_timer_timeout():
	canpress = true
