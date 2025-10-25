extends Node2D

##base info needed for UI and the level up system
@export var statID = "HP"
@export var isStat_Ability_Bonus = 1
@export var UI_Title = "HP"
@export var UI_TitleSmall = "HP"
@export var UI_IconSmall = 0
@export var UI_ImageNmr = 0
var maxLevel = 6

##internal var keeping the level of the stat and the level for the UI stat
var level = 0
var UI_level = "1"
var UI_CardLevel ="1"
var UI_AmountToIncreaseDecrease = "+1"

##This is the amount of stats that will be increased + The info the UI needs
@export var level1AmountToIncreaseDecrease = 1
@export var UI_level1AmountToIncreaseDecrease = "+1"

var isMaxLevel = false
var isAssigned = false
var numberAssigned = 0 

@export var AmountToIncrease = [1, 2]


# Called when the node enters the scene tree for the first time.
func _ready():
	if statID == "MAXED":
		UI_CardLevel = "Recover"
	maxLevel = AmountToIncrease.size()
	UI_AmountToIncreaseDecrease = str(UI_level1AmountToIncreaseDecrease)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level == maxLevel:
		isMaxLevel = true
		UI_level = "MAX"

func levelUp(ButtonNumber):
	match isStat_Ability_Bonus:
		1:
			if level < maxLevel && statID != "MAXED":
				##Update the stats by matching the level to the amountToIncrease array
				UpdateStats(AmountToIncrease[level])
				
				##Set the UI based on the level
				##Up the level
				level +=1
				UI_level = "Lv. " + str(level)
				UI_CardLevel = str(level + 1)
				if level < maxLevel:
					if statID == "COOLDOWN":
						UI_AmountToIncreaseDecrease = "-" + str(AmountToIncrease[level]) + "%"
					else:
						UI_AmountToIncreaseDecrease = "+" + str(AmountToIncrease[level])
			if level >= maxLevel:
				UI_level = "MAX"
				pass
			if statID == "MAXED":
					UI_level = "Recover"
					UpdateStats(0)
				
		2:
			updateSpells(ButtonNumber)
			pass
		3:
			updateBonus()
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
			
		"BOUNCE":
			Globalsettings.currentrun_extrabounce += amountToIncreaseDecrease
			
		"MAXED":
			get_tree().call_group("crowd_m", "updateHp")

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

func updateBonus():
	match statID:
		"EXTRAMEEBLING":
			var arrow = get_tree().get_first_node_in_group("CrowdSimulation")
			arrow.birthMeebling(arrow.global_position)
			pass
	pass
