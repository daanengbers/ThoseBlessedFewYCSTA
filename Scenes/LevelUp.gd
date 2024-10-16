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

func _ready():
	##Here we initialise all the stats that can be chosen
	$UI/LevelUpUI/CardArrow/Anim.play("play")
	
	var HPStat = $HPStat
	var ATTACKStat = $ATTACKStat
	var COOLDOWNStat = $COOLDOWNStat
	var SPEEDStat = $SPEEDStat
	var AMOUNTStat = $AMOUNTStat
	
	var UI_LockedStat1 = $UI/LockedStat1
	var UI_LockedStat2 = $UI/LockedStat2
	var UI_LockedStat3 = $UI/LockedStat3
	var UI_LockedStat4 = $UI/LockedStat4
	
	##Here we add the stats to an array
	StatArray = [HPStat, ATTACKStat, COOLDOWNStat, SPEEDStat, AMOUNTStat]
	
	##Here we add the UI stat slots to an array
	LockedUIArray = [UI_LockedStat1, UI_LockedStat2, UI_LockedStat3, UI_LockedStat4]
	
	##CHECK IF ALL STATS ARE LOCKED, IF YES ALLOW ONLY THE LOCKED STATS IF NO ALLOW ALL - done
	##CHECK IF STAT IS MAX LEVEL, IF YES REMOVE FROM LIST, IF NO DO NOTHING - done
	##RANDOM PICK STATS - done
	##READ RANDOM PICKED STATS - done
	##SPAWN CARDS WITH THE READ DATA - done
	##GIVE CHOISE TO PLAYER - done
	##ALLOW TO PICK - done
	##ASSIGN AND LOCK STAT - done
	##CHANGE STATS - done
	##CHANGE UI FOR THE NEXT CARDS - done

func _process(delta):
	##Test function to rerol stats
	if Input.is_action_pressed("aim"):
		testCleanup()
		levelUpInit()
		pass
	
	##Select card
	if inmenu == true:
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
			stat1.levelUp()
			
			##If the stat is already locked, we search for the slot it is assigned to and update its UI
			if stat1.isAssigned == true:
				print(stat1.numberAssigned)
				LockedUIArray[stat1.numberAssigned - 1].UpdateUI(stat1.UI_level, stat1.UI_TitleSmall)
			
			##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
			if stat1.isAssigned == false:
				assignStatToSlot(stat1)
		if cardselected == 2:
			##This calls a function in the chosen stat to level up and update the vars
			stat2.levelUp()
			
			##If the stat is already locked, we search for the slot it is assigned to and update its UI
			if stat2.isAssigned == true:
				LockedUIArray[stat2.numberAssigned - 1].UpdateUI(stat2.UI_level, stat2.UI_TitleSmall)
				
			##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
			if stat2.isAssigned == false:
				assignStatToSlot(stat2)
				
		if cardselected == 3:
			##This calls a function in the chosen stat to level up and update the vars
			stat3.levelUp()
			
			##If the stat is already locked, we search for the slot it is assigned to and update its UI
			if stat3.isAssigned == true:
				LockedUIArray[stat3.numberAssigned - 1].UpdateUI(stat3.UI_level, stat3.UI_TitleSmall)
			
			##If the chosen stat is not assigned yet it runs a function to assign it to the right slot
			if stat3.isAssigned == false:
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
		for i in StatArray.size():
			if StatArray[i].isMaxLevel == true:
				StatArray.remove(i)
		
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
			lockedStatArray = [FirstStat,SeccondStat,ThirdStat,FourthStat]
			FirstTimeAllLocked = false
		
		##This loops through the array of the locked stats, if one of them is maxed out, it removes them and replaces them with a maxed out card
		for i in lockedStatArray.size():
			if lockedStatArray[i].isMaxLevel == true:
				lockedStatArray.remove(i)
				lockedStatArray.assign(maxLevelReachedCard)
		
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
	ca.UpdateCardUI(stat.UI_Title,stat.UI_CardLevel,stat.UI_AmountToIncreaseDecrease)
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
					LockedUIArray[0].UpdateUI("LVl 1", FirstStat.UI_TitleSmall)
					
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
					LockedUIArray[1].UpdateUI("LVl 1", SeccondStat.UI_TitleSmall)
					
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
					LockedUIArray[2].UpdateUI("LVl 1", ThirdStat.UI_TitleSmall)
					
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
					LockedUIArray[3].UpdateUI("LVl 1", FourthStat.UI_TitleSmall)
					
					##Up the slot to lock
					currentStatToLock += 1
	if currentStatToLock > maxStatToLock:
		allSlotLocked = true

func testCleanup():
	card1.queue_free()
	card2.queue_free()
	card3.queue_free()

func _on_unpause_timer_level_up_timeout():
	
	pressed = false
	inmenu = false
	$UI/LevelUpUI.visible = false
	##Used for testing
	testCleanup()
	##levelUpInit()
	
	##When done this should be reanabled and continues the game
	get_tree().paused = false
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
