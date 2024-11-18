extends Node2D

var OptionSelected = 1
var InMenu = false
var isPressed = false
var unpausePossible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	updateArrow()
	$OptionButtons/OptionsArrow/Anim.play("play")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if InMenu == true:
		print_debug(OptionSelected)
		if Input.is_action_just_pressed("down") && OptionSelected < 3:
			OptionSelected += 1
			updateArrow()
			pass
		if Input.is_action_just_pressed("up") && OptionSelected > 1:
			OptionSelected -= 1
			updateArrow()
			pass
			
		if Input.is_action_just_pressed("Pause") && unpausePossible == true:
			unpausePossible = false
			unpauseGame()
			
		if Input.is_action_just_pressed("spell1") or Input.is_action_just_pressed("spell2") or Input.is_action_just_pressed("spell3") or Input.is_action_just_pressed("spell4") && isPressed == false:
			match OptionSelected:
				1:
					isPressed = true
					unpauseGame()
					pass
				2:
					pass
				3:
					pass
			pass
	
func updateArrow():
	match OptionSelected:
		1:
			$OptionButtons/OptionsArrow.position.y = 71
		2:
			$OptionButtons/OptionsArrow.position.y = 103
		3:
			$OptionButtons/OptionsArrow.position.y = 135
	pass

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


func _on_unpause_timer_timeout():
	unpausePossible = true
	pass # Replace with function body.
