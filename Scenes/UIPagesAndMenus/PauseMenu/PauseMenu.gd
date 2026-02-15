extends Node2D

var OptionSelected = 1
var InMenu = false
var isPressed = false
var unpausePossible = false

var isInMenu = true
var isInSettings = false
var isInAYS = false
var settingSelected = 1
var AYSSelected = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	updateArrow()
	$OptionButtons/OptionsArrow/Anim.play("play")
	$Settings/Selecticon/Iconanim.play("flame")
	$AreYouSure/AYSArrow/Anim.play("play")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print_debug(isInAYS)
	if InMenu == true:
		##Normal controlls
		if Input.is_action_just_pressed("down") && OptionSelected < 3  && isInSettings == false && isInAYS == false:
			OptionSelected += 1
			updateArrow()
			pass
		if Input.is_action_just_pressed("up") && OptionSelected > 1 && isInSettings == false && isInAYS == false:
			OptionSelected -= 1
			updateArrow()
			pass
		if Input.is_action_just_pressed("Pause") && unpausePossible == true  && isInSettings == false && isInAYS == false:
			unpausePossible = false
			unpauseGame()
		if Input.is_action_just_pressed("spell1") or Input.is_action_just_pressed("spell2") or Input.is_action_just_pressed("spell3") or Input.is_action_just_pressed("spell4") && isPressed == false  && isInSettings == false && isInAYS == false:
			match OptionSelected:
				1:
					unpauseGame()
					buttonPressed()
				2:
					if isInSettings == false && isPressed == false:
						goToSettings()
						buttonPressed()
				3:
					if isInAYS == false && isPressed == false:
						goToAYS()
						buttonPressed()
			pass
		##Setting controlls
		if Input.is_action_just_pressed("left") && isInSettings == true  && isInSettings == true && isInAYS == false: 
			if settingSelected == 1 && Globalsettings.global_SFXvol > 0:
				Globalsettings.global_SFXvol -= 0.05
				$Settings/SFX_bar.value = Globalsettings.global_SFXvol
			if settingSelected == 2 && Globalsettings.global_Musicvol > 0:
				Globalsettings.global_Musicvol -= 0.05
				$Settings/Music_bar.value = Globalsettings.global_Musicvol
			if settingSelected == 3:
				if Globalsettings.global_showfps == false:
					Globalsettings.global_showfps = true
					$Settings/Setting04.set_text("Show FPS: ON >")
			if settingSelected == 4:
				if Globalsettings.global_fullscreen == false:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
					Globalsettings.global_fullscreen = true
					$Settings/Setting05.set_text("Full Screen: ON >")
		if Input.is_action_just_pressed("right") && isInSettings == true && isInAYS == false:
			if settingSelected == 1 && Globalsettings.global_SFXvol < 1:
				Globalsettings.global_SFXvol += 0.05
				$Settings/SFX_bar.value = Globalsettings.global_SFXvol
			if settingSelected == 2 && Globalsettings.global_Musicvol < 1:
				Globalsettings.global_Musicvol += 0.05
				$Settings/Music_bar.value = Globalsettings.global_Musicvol
			if settingSelected == 3:
				if Globalsettings.global_showfps == true:
						Globalsettings.global_showfps = false
						$Settings/Setting04.set_text("Show FPS: < OFF>")
			if settingSelected == 4:
				if Globalsettings.global_fullscreen == true:
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
						Globalsettings.global_fullscreen = false
						$Settings/Setting05.set_text("Full Screen: < OFF")
		if Input.is_action_just_pressed("up") && settingSelected > 0  && isInSettings == true && isInAYS == false:
			settingSelected -= 1
			updateSettingArrow()
		if Input.is_action_just_pressed("down") && settingSelected < 5 && isInSettings == true && isInAYS == false:
			settingSelected += 1
			updateSettingArrow()
		if Input.is_action_just_pressed("spell1") or Input.is_action_just_pressed("spell2") or Input.is_action_just_pressed("spell3") or Input.is_action_just_pressed("spell4") && isPressed == false  && isInSettings == true && isInAYS == false:
			match settingSelected:
				1:
					pass
				2:
					pass
				3:
					pass
				4:
					pass
				5:
					if isInSettings == true && isPressed == false:
						goAwayFromSettings()
						buttonPressed()
		if Input.is_action_just_pressed("Pause") && isInSettings == true && isInAYS == false:
			goAwayFromSettings()
		if Input.is_action_just_pressed("left") && isInAYS == true && isInSettings == false && AYSSelected == 2:
			AYSSelected -=1
			AYSArrow()
			pass
		if Input.is_action_just_pressed("right") && isInAYS == true && isInSettings == false && AYSSelected == 1:
			AYSSelected +=1 
			AYSArrow()
			pass
		if Input.is_action_just_pressed("spell1") or Input.is_action_just_pressed("spell2") or Input.is_action_just_pressed("spell3") or Input.is_action_just_pressed("spell4") && isPressed == false && isInSettings == false && isInAYS == true:
			if AYSSelected == 1 && isInAYS == true && isPressed == false:
				goAwayFromAYS()
				buttonPressed()
			if AYSSelected == 2 && isInAYS == true && isPressed == false:
				goToMainMenu()
			pass
		if Input.is_action_just_pressed("Pause") && isInAYS == true && isInSettings == false:
			goAwayFromAYS()
func updateArrow():
	match OptionSelected:
		1:
			$OptionButtons/OptionsArrow.position.y = 71
		2:
			$OptionButtons/OptionsArrow.position.y = 103
		3:
			$OptionButtons/OptionsArrow.position.y = 135
	
func updateSettingArrow():
	match settingSelected:
		1:
			$Settings/Selecticon.position.y = 82
		2:
			$Settings/Selecticon.position.y = 102
		3:
			$Settings/Selecticon.position.y = 117
		4:
			$Settings/Selecticon.position.y = 129
		5:
			$Settings/Selecticon.position.y = 151
			
func AYSArrow():
	match AYSSelected:
		1:
			$AreYouSure/AYSArrow.position.x = 98
		2:
			$AreYouSure/AYSArrow.position.x = 234
	pass

func goToSettings():
	$Settings/Music_bar.value = Globalsettings.global_Musicvol
	$Settings/SFX_bar.value = Globalsettings.global_SFXvol
	settingSelected = 1
	isInSettings = true
	$OptionButtons.visible = false
	$Settings.visible = true
	updateSettingArrow()
	pass
	
func goAwayFromSettings():
	isInSettings = false
	$Settings.visible = false
	$OptionButtons.visible = true
	updateSettingArrow()
	pass
	
func goToAYS():
	$OptionButtons.visible = false
	$StatSheet.visible = false
	$AreYouSure.visible = true
	isInAYS = true
	AYSSelected = 1
	AYSArrow()
	
func goAwayFromAYS():
	$OptionButtons.visible = true
	$StatSheet.visible = true
	$AreYouSure.visible = false
	isInAYS = false
	AYSSelected = 1
	AYSArrow()

func pauseGame():
	OptionSelected = 1
	$".".visible = true
	get_tree().paused = true
	InMenu = true
	unpausePossible = false
	$UnpauseTimer.start(0.5)
	
func unpauseGame():
	InMenu = false
	isPressed = false
	$".".visible = false
	get_tree().paused = false

func goToMainMenu():
	get_tree().paused = false
	Globalsettings.resetrun()
	get_tree().change_scene_to_file("res://Scenes/new_titlescreen.tscn")
	
func buttonPressed():
	isPressed = true
	$PressedTimer.start(0.1)

func _on_unpause_timer_timeout():
	unpausePossible = true
	pass # Replace with function body.


func _on_sfx_bar_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	Globalsettings.global_SFXvol = value
	pass # Replace with function body.


func _on_music_bar_value_changed(value):
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	Globalsettings.global_Musicvol = value
	pass # Replace with function body.


func _on_pressed_timer_timeout():
	isPressed = false
	pass # Replace with function body.
