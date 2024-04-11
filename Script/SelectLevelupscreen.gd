extends Node2D

var CARD = preload("res://Scenes/card.tscn")
var cardselected = 1

var inmenu = false
var pressed = false

var card1
var card2
var card3

func _ready():
	$CardArrow/Anim.play("play")



func _process(delta):
	
	if inmenu == true:
		if Input.is_action_just_pressed("right") && cardselected < 3 && pressed == false:
			cardselected += 1
			setselectarrow()
		if Input.is_action_just_pressed("left") && cardselected > 1 && pressed == false:
			cardselected -= 1
			setselectarrow()
		
		#Spells select
		
		if Input.is_action_just_pressed("spell1") && pressed == false:
			$CardSelect.play()
			pressed  = true
			if cardselected == 1:
				card1.selectcard(1)
			if cardselected == 2:
				card2.selectcard(1)
			if cardselected == 3:
				card3.selectcard(1)
			$UnpauseTimer.start()
		
		if Input.is_action_just_pressed("spell2") && pressed == false:
			$CardSelect.play()
			pressed  = true
			if cardselected == 1:
				card1.selectcard(2)
			if cardselected == 2:
				card2.selectcard(2)
			if cardselected == 3:
				card3.selectcard(2)
			$UnpauseTimer.start()
		
		if Input.is_action_just_pressed("spell3") && pressed == false:
			$CardSelect.play()
			pressed  = true
			if cardselected == 1:
				card1.selectcard(3)
			if cardselected == 2:
				card2.selectcard(3)
			if cardselected == 3:
				card3.selectcard(3)
			$UnpauseTimer.start()
		
		if Input.is_action_just_pressed("spell4") && pressed == false:
			$CardSelect.play()
			pressed  = true
			if cardselected == 1:
				card1.selectcard(4)
			if cardselected == 2:
				card2.selectcard(4)
			if cardselected == 3:
				card3.selectcard(4)
			$UnpauseTimer.start()
		
		
		
		
		
		
		
		
		
		
	

func setselectarrow():
	if cardselected == 1:
		$CardArrow.position.x = 90
	if cardselected == 2:
		$CardArrow.position.x = 160
	if cardselected == 3:
		$CardArrow.position.x = 230

func spawncards(xpos):
	var ca = CARD.instantiate()
	add_child.call_deferred(ca)
	ca.position.x = xpos
	ca.position.y = global_position.y + 100
	if xpos == 90:
		card1 = ca
	if xpos == 160:
		card2 = ca
	if xpos == 230:
		card3 = ca

func _on_unpause_timer_timeout():
	get_tree().paused = false
	inmenu = false
	visible = false
	card1.queue_free()
	card2.queue_free()
	card3.queue_free()
	get_parent().get_parent().displayupgrades()
