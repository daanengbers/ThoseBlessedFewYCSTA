extends Node2D

var CARD = preload("res://Scenes/cardNew.tscn")

##These stats hold the randomly picked stats, they keep getting reassigned on every level up
var stat1 
var stat2
var stat3

##These get linked to the spawned cards
var card1
var card2
var card3

##These will be used to lock the chosen stats
var FirstStat
var SeccondStat
var ThirdStat
var FourthStat

##These will be used to controll and check the locked stats
var currentStatToLock = 1
var maxStatToLock = 4
var allSlotLocked = false

##these keep the arrays of the cards that can be chosen
var pickedCards
var StatArray
var lockedStatArray

##these controll the menu functionality
var inmenu = false
var pressed = false
var cardselected = 1
var canselectcard = false

var maxLevelReachedCard
var FirstTimeAllLocked = true

##This array is used to set the correct UI for the locked stats
var LockedUIArray

var statToRemove

@onready var HP_Stat = $Stats/HP_Stat
@onready var ATTACK_Stat = $Stats/ATTACK_Stat
@onready var COOLDOWN_Stat = $Stats/COOLDOWN_Stat
@onready var SPEED_Stat = $Stats/SPEED_Stat
@onready var AMOUNT_Stat = $Stats/AMOUNT_Stat

@onready var FIREBALL_Ability = $Abilities/FIREBALL_Ability
@onready var LIGHTNING_Ability = $Abilities/LIGHTNING_Abiltiy
@onready var POISON_Ability = $Abilities/POISON_Ability
@onready var ICE_Ability = $Abilities/ICE_Ability

@onready var MAX_Stat = $Stats/MAXED_Stat

func _ready():
	##Here we initialise all the stats that can be chosen
	$UI/LevelUpUI/CardArrow/Anim.play("play")
	
	
	
	var UI_LockedStat1 = $UI/LockedStat1
	var UI_LockedStat2 = $UI/LockedStat2
	var UI_LockedStat3 = $UI/LockedStat3
	var UI_LockedStat4 = $UI/LockedStat4
	
	##Here we add the stats to an array
	StatArray = [HP_Stat, ATTACK_Stat, COOLDOWN_Stat, SPEED_Stat, AMOUNT_Stat, FIREBALL_Ability, LIGHTNING_Ability, POISON_Ability, ICE_Ability]
	
	##Here we add the UI stat slots to an array
	LockedUIArray = [UI_LockedStat1, UI_LockedStat2, UI_LockedStat3, UI_LockedStat4, FIREBALL_Ability, LIGHTNING_Ability, ICE_Ability, POISON_Ability]
	

func _process(delta):
	
	if inmenu == true:
		##Select card
		if Input.is_action_just_pressed("right") && cardselected < 3 && pressed == false:
			cardselected += 1
			setselectarrow()
		if Input.is_action_just_pressed("left") && cardselected > 1 && pressed == false:
			cardselected -= 1
			setselectarrow()
	
		##Pick a card
		if Input.is_action_just_pressed("spell1") && pressed == false && canselectcard == true:
			pressed  = true
			if cardselected == 1:			
				##This calls a function in the chosen stat to level up and update the vars
				stat1.levelUp(1)
				card1.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat1.isAssigned == true && stat1.isAbility == false:
					print(stat1.numberAssigned)
					LockedUIArray[stat1.numberAssigned - 1].UpdateUI(stat1.UI_level, stat1.UI_TitleSmall)
				
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat1.isAssigned == false && stat1.isAbility == false:
					assignStatToSlot(stat1)
			if cardselected == 2:
				##This calls a function in the chosen stat to level up and update the vars
				stat2.levelUp(1)
				card2.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat2.isAssigned == true && stat2.isAbility == false:
					LockedUIArray[stat2.numberAssigned - 1].UpdateUI(stat2.UI_level, stat2.UI_TitleSmall)
					
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat2.isAssigned == false && stat2.isAbility == false:
					assignStatToSlot(stat2)
					
			if cardselected == 3:
				##This calls a function in the chosen stat to level up and update the vars
				stat3.levelUp(1)
				card3.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat3.isAssigned == true && stat3.isAbility == false:
					LockedUIArray[stat3.numberAssigned - 1].UpdateUI(stat3.UI_level, stat3.UI_TitleSmall)
				
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat3.isAssigned == false && stat3.isAbility == false:
					assignStatToSlot(stat3)
			$UnpauseTimerLevelUp.start()
			
		if Input.is_action_just_pressed("spell2") && pressed == false && canselectcard == true:
			pressed  = true
			if cardselected == 1:			
				##This calls a function in the chosen stat to level up and update the vars
				stat1.levelUp(2)
				card1.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat1.isAssigned == true && stat1.isAbility == false:
					print(stat1.numberAssigned)
					LockedUIArray[stat1.numberAssigned - 1].UpdateUI(stat1.UI_level, stat1.UI_TitleSmall)
				
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat1.isAssigned == false && stat1.isAbility == false:
					assignStatToSlot(stat1)
			if cardselected == 2:
				##This calls a function in the chosen stat to level up and update the vars
				stat2.levelUp(2)
				card2.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat2.isAssigned == true && stat2.isAbility == false:
					LockedUIArray[stat2.numberAssigned - 1].UpdateUI(stat2.UI_level, stat2.UI_TitleSmall)
					
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat2.isAssigned == false && stat2.isAbility == false:
					assignStatToSlot(stat2)
					
			if cardselected == 3:
				##This calls a function in the chosen stat to level up and update the vars
				stat3.levelUp(2)
				card3.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat3.isAssigned == true && stat3.isAbility == false:
					LockedUIArray[stat3.numberAssigned - 1].UpdateUI(stat3.UI_level, stat3.UI_TitleSmall)
				
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat3.isAssigned == false && stat3.isAbility == false:
					assignStatToSlot(stat3)
			$UnpauseTimerLevelUp.start()
			
		if Input.is_action_just_pressed("spell3") && pressed == false && canselectcard == true:
			pressed  = true
			if cardselected == 1:			
				##This calls a function in the chosen stat to level up and update the vars
				stat1.levelUp(3)
				card1.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat1.isAssigned == true && stat1.isAbility == false:
					print(stat1.numberAssigned)
					LockedUIArray[stat1.numberAssigned - 1].UpdateUI(stat1.UI_level, stat1.UI_TitleSmall)
				
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat1.isAssigned == false && stat1.isAbility == false:
					assignStatToSlot(stat1)
			if cardselected == 2:
				##This calls a function in the chosen stat to level up and update the vars
				stat2.levelUp(3)
				card2.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat2.isAssigned == true && stat2.isAbility == false:
					LockedUIArray[stat2.numberAssigned - 1].UpdateUI(stat2.UI_level, stat2.UI_TitleSmall)
					
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat2.isAssigned == false && stat2.isAbility == false:
					assignStatToSlot(stat2)
					
			if cardselected == 3:
				##This calls a function in the chosen stat to level up and update the vars
				stat3.levelUp(3)
				card3.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat3.isAssigned == true && stat3.isAbility == false:
					LockedUIArray[stat3.numberAssigned - 1].UpdateUI(stat3.UI_level, stat3.UI_TitleSmall)
				
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat3.isAssigned == false && stat3.isAbility == false:
					assignStatToSlot(stat3)
			$UnpauseTimerLevelUp.start()
			
		if Input.is_action_just_pressed("spell4") && pressed == false && canselectcard == true:
			pressed  = true
			if cardselected == 1:			
				##This calls a function in the chosen stat to level up and update the vars
				stat1.levelUp(4)
				card1.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat1.isAssigned == true && stat1.isAbility == false:
					print(stat1.numberAssigned)
					LockedUIArray[stat1.numberAssigned - 1].UpdateUI(stat1.UI_level, stat1.UI_TitleSmall)
				
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat1.isAssigned == false && stat1.isAbility == false:
					assignStatToSlot(stat1)
			if cardselected == 2:
				##This calls a function in the chosen stat to level up and update the vars
				stat2.levelUp(4)
				card2.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat2.isAssigned == true && stat2.isAbility == false:
					LockedUIArray[stat2.numberAssigned - 1].UpdateUI(stat2.UI_level, stat2.UI_TitleSmall)
					
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat2.isAssigned == false && stat2.isAbility == false:
					assignStatToSlot(stat2)
					
			if cardselected == 3:
				##This calls a function in the chosen stat to level up and update the vars
				stat3.levelUp(4)
				card3.selectcardAnim()
				##If the stat is already locked, we search for the slot it is assigned to and update its UI
				if stat3.isAssigned == true && stat3.isAbility == false:
					LockedUIArray[stat3.numberAssigned - 1].UpdateUI(stat3.UI_level, stat3.UI_TitleSmall)
				
				##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
				if stat3.isAssigned == false && stat3.isAbility == false:
					assignStatToSlot(stat3)
			$UnpauseTimerLevelUp.start()

func levelUpInit():
	##Begins the level up process
	$UI/LevelUpUI.visible = true
	pressed = false
	inmenu = true
	
	##Checks if all stat slots are locked
	if allSlotLocked == false:
		##Loop through the stats and remove the ones that are fully leveled
		for Stati in StatArray.size():
			if StatArray[Stati].isMaxLevel == true:
				statToRemove = Stati
		if statToRemove != null && StatArray[statToRemove].isMaxLevel == true:
			StatArray.remove_at(statToRemove)
		
		##randomise stats in array
		StatArray.shuffle()
		
		##pick the first 3 cards in the array
		pickedCards = StatArray.slice(0, 3)
		
		##set the var that represent the stat the card holds
		stat1 = pickedCards[0]
		stat2 = pickedCards[1]
		stat3 = pickedCards[2]
		
		##Spawn three cards and assign the randomly picked stats
		spawncards(90, stat1)
		spawncards(160, stat2)
		spawncards(230, stat3)
		
	#Checks if all stat slots are locked
	if allSlotLocked == true:
		##The first time you level up after all stats are locked, it makes a new list with the locked stats
		if FirstTimeAllLocked == true:
			lockedStatArray = [FirstStat,SeccondStat,ThirdStat,FourthStat, FIREBALL_Ability, POISON_Ability, ICE_Ability, LIGHTNING_Ability]
			FirstTimeAllLocked = false
		
		##This loops through the array of the locked stats, if one of them is maxed out, it removes them and replaces them with a maxed out card
		for i in lockedStatArray.size():
			if lockedStatArray[i].isMaxLevel == true:
				lockedStatArray.remove_at(i)
				lockedStatArray.append(MAX_Stat)
		
		##randomise stats in locked array
		lockedStatArray.shuffle()
		
		##pick the first 3 cards in the array
		pickedCards = lockedStatArray.slice(0,3)
		
		##set the var that represent the stat the card holds
		stat1 = pickedCards[0]
		stat2 = pickedCards[1]
		stat3 = pickedCards[2]
		
		##Spawn three cards and assign the randomly picked stats
		spawncards(90, stat1)
		spawncards(160, stat2)
		spawncards(230, stat3)

func spawncards(xpos, stat):
	##canselectcard = false
	$CanpressTimerLevelUp.start()
	$ConfettiLevelUp.emitting = true
	var ca = CARD.instantiate()
	ca.UpdateCardUI(stat.UI_Title,stat.UI_CardLevel,stat.UI_AmountToIncreaseDecrease, stat.UI_ImageNmr)
	##add_child.call_deferred(ca)
	$UI/LevelUpUI.add_child(ca)
	ca.position.x = xpos
	ca.position.y = global_position.y + 100
	if xpos == 90:
		card1 = ca
	if xpos == 160:
		card2 = ca
	if xpos == 230:
		card3 = ca

func setselectarrow():
	##Move the arrow to the selected card
	if cardselected == 1:
		$UI/LevelUpUI/CardArrow.position.x = 90
	if cardselected == 2:
		$UI/LevelUpUI/CardArrow.position.x = 160
	if cardselected == 3:
		$UI/LevelUpUI/CardArrow.position.x = 230

func assignStatToSlot(statToAssign):
	if currentStatToLock <= maxStatToLock:
		match currentStatToLock:
			1:
					##Assign the stat to the correct slot
					FirstStat = statToAssign
					
					##Enable a bool in the stat that tels it it is assigned
					FirstStat.isAssigned = true
					
					##Set the correct slot number to the stat
					FirstStat.numberAssigned = 1
					
					##Initialise the UI of the slot
					LockedUIArray[0].UpdateUI("Lv. 1", FirstStat.UI_IconSmall)
					
					##Up the slot to lock
					currentStatToLock += 1
					pass
			2:
					##Assign the stat to the correct slot
					SeccondStat = statToAssign
					
					##Enable a bool in the stat that tels it it is assigned
					SeccondStat.isAssigned = true
					
					##Set the correct slot number to the stat
					SeccondStat.numberAssigned = 2
					
					##Initialise the UI of the slot
					LockedUIArray[1].UpdateUI("Lv. 1", SeccondStat.UI_IconSmall)
					
					##Up the slot to lock
					currentStatToLock += 1
			3:
					##Assign the stat to the correct slot
					ThirdStat = statToAssign
					
					##Enable a bool in the stat that tels it it is assigned
					ThirdStat.isAssigned = true
					
					##Set the correct slot number to the stat
					ThirdStat.numberAssigned = 3
					
					##Initialise the UI of the slot
					LockedUIArray[2].UpdateUI("Lv. 1", ThirdStat.UI_IconSmall)
					
					##Up the slot to lock
					currentStatToLock += 1
					pass
			4:
					##Assign the stat to the correct slot
					FourthStat = statToAssign
					
					##Enable a bool in the stat that tels it it is assigned
					FourthStat.isAssigned = true
					
					##Set the correct slot number to the stat
					FourthStat.numberAssigned = 4
					
					##Initialise the UI of the slot
					LockedUIArray[3].UpdateUI("Lv. 1", FourthStat.UI_IconSmall)
					
					##Up the slot to lock
					currentStatToLock += 1
	if currentStatToLock > maxStatToLock:
		allSlotLocked = true

func testCleanup():
	card1.queue_free()
	card2.queue_free()
	card3.queue_free()

func _on_unpause_timer_level_up_timeout():
	get_tree().paused = false
	pressed = false
	inmenu = false
	$UI/LevelUpUI.visible = false
	get_parent().get_parent().displayupgrades()
	testCleanup()
	##levelUpInit()
	
	##When done this should be reanabled and continues the game
	
	##inmenu = false
	##visible = false
	##card1.queue_free()
	##card2.queue_free()
	##card3.queue_free()
	##get_parent().get_parent().displayupgrades()
	pass # Replace with function body.

func _on_canpress_timer_level_up_timeout():
	canselectcard = true
	pass # Replace with function body.
