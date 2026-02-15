extends Node2D

var YESCARD = preload("res://Scenes/cardYesOption.tscn")
var NOCARD = preload("res://Scenes/cardNoOption.tscn")

var cardselected = 1
var canselectcard = false

var inmenu = false
var pressed = false

var sacCard1
var sacCard2
var sacCard3

var OpenWay = false

var canSac
# Called when the node enters the scene tree for the first time.
func _ready():
	$CardArrowSac/Anim.play("play")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if inmenu == true:
		if Input.is_action_just_pressed("right") && cardselected < 2 && $"../..".canSac == true && pressed == false:
			cardselected += 1
			setselectarrow()
		if Input.is_action_just_pressed("left") && cardselected > 1 && $"../..".canSac && pressed == false:
			cardselected -= 1
			setselectarrow()
	
		if Input.is_action_just_pressed("spell1") && pressed == false && canselectcard == true:
			pressed  = true
			if cardselected == 1:
				sacCard1.selectcardSac(1)
				$"../..".SacMeeblings()
				pass
			if cardselected == 2:
				sacCard2.selectcardSac(1)
			if cardselected == 3:
				#card3.selectcardSac(1)
				pass
			$UnpauseTimerSac.start()
		
		if Input.is_action_just_pressed("spell2") && pressed == false && canselectcard == true:
			pressed  = true
			if cardselected == 1:
				sacCard1.selectcardSac(2)
				$"../..".SacMeeblings()
				pass
			if cardselected == 2:
				sacCard2.selectcardSac(2)
			if cardselected == 3:
				sacCard3.selectcardSac(2)
				pass
			$UnpauseTimerSac.start()
		
		if Input.is_action_just_pressed("spell3") && pressed == false && canselectcard == true:
			pressed  = true
			if cardselected == 1:
				sacCard1.selectcardSac(3)
				$"../..".SacMeeblings()
				pass
			if cardselected == 2:
				sacCard2.selectcardSac(3)
				$"../..".SacMeeblings()
			if cardselected == 3:
				sacCard3.selectcardSac(3)
				pass
			$UnpauseTimerSac.start()
		
		if Input.is_action_just_pressed("spell4") && pressed == false && canselectcard == true:
			pressed  = true
			if cardselected == 1:
				sacCard1.selectcardSac(4)
				$"../..".SacMeeblings()
				pass
			if cardselected == 2:
				sacCard2.selectcardSac(4)
			if cardselected == 3:
				sacCard3.selectcardSac(4)
				pass
			$UnpauseTimerSac.start()
	
func setselectarrow():
	if cardselected == 1:
		$CardArrowSac.position.x = 110
	if cardselected == 2:
		$CardArrowSac.position.x = 210
	if cardselected == 3:
		$CardArrowSac.position.x = 160

func spawncards(xpos, YesOrNo, numberToAssign):
	canselectcard = false
	$CanpressTimerSac.start()
	$ConfettiSac.emitting = true
	if YesOrNo == 1:
		var YesCa = YESCARD.instantiate()
		add_child.call_deferred(YesCa)
		YesCa.position.x = xpos
		YesCa.position.y = global_position.y + 100
		if xpos == 110:
			sacCard1 = YesCa
		
	if YesOrNo == 2:
		var NoCa = NOCARD.instantiate()
		add_child.call_deferred(NoCa)
		NoCa.position.x = xpos
		NoCa.position.y = global_position.y + 100
		if xpos == 210:
			sacCard2 = NoCa
		if xpos == 160:
			sacCard3 = NoCa
		
	if YesOrNo == 3:
		cardselected = 3
		setselectarrow()
		var NoCa = NOCARD.instantiate()
		add_child.call_deferred(NoCa)
		NoCa.position.x = xpos
		NoCa.position.y = global_position.y + 100
		if xpos == 210:
			sacCard2 = NoCa
		if xpos == 160:
			sacCard3 = NoCa
		
		



func _on_unpause_timer_sac_timeout():
	get_tree().paused = false
	inmenu = false
	visible = false
	if $"../..".canSac == true:
		sacCard1.queue_free()
		sacCard2.queue_free()
	if $"../..".canSac == false:
		sacCard3.queue_free()
	pass # Replace with function body.


func _on_canpress_timer_sac_timeout():
	canselectcard = true
	pass # Replace with function body.
