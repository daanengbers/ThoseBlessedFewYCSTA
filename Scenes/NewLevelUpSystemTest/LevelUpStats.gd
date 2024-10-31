extends Node2D

##base info needed for UI and the level up system
@export var statID = "HP"
@export var isAbility = true
@export var UI_Title = "HP"
@export var UI_TitleSmall = "HP"
@export var UI_IconSmall = 0
@export var UI_ImageNmr = 0
@export var maxLevel = 6

##internal var keeping the level of the stat and the level for the UI stat
var level = 1
var UI_level = "1"
var UI_CardLevel ="1"
var UI_AmountToIncreaseDecrease = "+1"

##This is the amount of stats that will be increased + The info the UI needs
@export var level1AmountToIncreaseDecrease = 1
@export var UI_level1AmountToIncreaseDecrease = "+1"

@export var level2AmountToIncreaseDecrease = 1
@export var UI_level2AmountToIncreaseDecrease = "+1"

@export var level3AmountToIncrease = 1
@export var UI_level3AmountToIncreaseDecrease = "+1"

@export var level4AmountToIncreaseDecrease = 1
@export var UI_level4AmountToIncreaseDecrease = "+1"

@export var level5AmountToIncrease = 1
@export var UI_level5AmountToIncreaseDecrease = "+1"

@export var level6AmountToIncreaseDecrease = 1
@export var UI_level6AmountToIncreaseDecrease = "+1"

var isMaxLevel = false
var isAssigned = false
var numberAssigned = 0 

@export var AmountToIncrease = ["Test1", "Test2"]


# Called when the node enters the scene tree for the first time.
func _ready():
	UI_AmountToIncreaseDecrease = str(UI_level1AmountToIncreaseDecrease)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func levelUp(ButtonNumber):
	match isAbility:
		false:
			##Check the level, update the UI, update the stats and up the level for next time
			match level:
				1:
					##Update the stats with the amount to increase of this level
					UpdateStats(level1AmountToIncreaseDecrease)
					
					##Set the UI for the locked lvl
					UI_level = "LVL 1"
					
					##Set the UI for the next card level
					UI_CardLevel = "2"
					
					##Set the UI for the next car amount to increase/decrease
					UI_AmountToIncreaseDecrease = str(UI_level1AmountToIncreaseDecrease)
					
					##Up the level by 1
					level += 1
				2:
					##Update the stats with the amount to increase of this level
					UpdateStats(level2AmountToIncreaseDecrease)
					
					
					UI_AmountToIncreaseDecrease = str(UI_level2AmountToIncreaseDecrease)
					UI_level = "LVL 2"
					UI_CardLevel = "3"
					level += 1
				3:
					UI_level = "LVL 3"
					UI_CardLevel = "4"
					level += 1
				4:
					UI_level = "LVL 4"
					UI_CardLevel = "5"
					level += 1
		true:
			updateSpells(ButtonNumber)
			pass

func UpdateStats(amountToIncreaseDecrease):
	##Check the statID and up the right stats
	match statID:
		"HP":
			Globalsettings.currentrun_extrahealth += amountToIncreaseDecrease
			get_tree().call_group("crowd_m", "updateHp")
			
		"ATTACK":
			Globalsettings.currentrun_extraattack += amountToIncreaseDecrease
			
		"SPEED":
			Globalsettings.currentrun_extraspeed += amountToIncreaseDecrease
			
		"COOLDOWN":
			Globalsettings.currentrun_minuscooldown += amountToIncreaseDecrease
			
		"AMOUNT":
			Globalsettings.currentrun_extrabullets += amountToIncreaseDecrease
		

func updateSpells(spellToSetNumber):
	match statID:
		"FIREBALL":
			match spellToSetNumber:
				1:
					Globalsettings.g_spell1 = 1
				2:
					Globalsettings.g_spell2 = 1
				3:
					Globalsettings.g_spell3 = 1
				4:
					Globalsettings.g_spell4 = 1
		"LIGHTNING":
			match spellToSetNumber:
				1:
					Globalsettings.g_spell1 = 2
				2:
					Globalsettings.g_spell2 = 2
				3:
					Globalsettings.g_spell3 = 2
				4:
					Globalsettings.g_spell4 = 2
		"POISON":
			match spellToSetNumber:
				1:
					Globalsettings.g_spell1 = 3
				2:
					Globalsettings.g_spell2 = 3
				3:
					Globalsettings.g_spell3 = 3
				4:
					Globalsettings.g_spell4 = 3
		"ICE":
			match spellToSetNumber:
				1:
					Globalsettings.g_spell1 = 4
				2:
					Globalsettings.g_spell2 = 4
				3:
					Globalsettings.g_spell3 = 4
				4:
					Globalsettings.g_spell4 = 4
