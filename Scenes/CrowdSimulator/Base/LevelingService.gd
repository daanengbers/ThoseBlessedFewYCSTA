extends Node

var xp : int
var xpNeededToLevelUp : int
var level : int

@onready var crowdSimulator : CharacterBody2D = get_parent()

var statLibrary: Dictionary = {}

func _ready():
	pass

func _process(delta):
	pass

##adds xp to the bar from varius sources
func GetXp(amount : int) -> void:
	pass

##When the bar is full, trigger a level up
##During a level up, 3(currently) cards show up, each card contains either a stat or an ability.
##When a stat or ability is chosen for the first time, it becomes level 1 and takes up a slot in the stat bar or ability bar(both max 4)
##When a stat or ability is included in the cards that has already been chosen, it can be leveled up, giving more stats when it is a stat or upgrading the functionality of the ability when it is an ability
##When a stat or ability has reached max level, it should be exluded from the pool of cards that can be shown
##When an ability has reached max level, and a specific stat has been chosen, a new card will be added to the pool
##When this card is chosen, the ability evolves, becoming much more powerfull
##The first time an ability is chosen, it is mapped to one of four buttons(which corrospond to slots in the ui). After this, the abilty can not be mapped to another ability(It is also not possible to have the same ability twice)
##When everything is leveled to the max, a couple of new cards get introduced into the pool giving small general upgrades.
func LevelUp() -> void:
	pass

##Library to keep stat varius and the amount they give for each level, as well as their max level
func LoadStats() -> void:
	statLibrary = {
		1: { ##Attack
			"cardName": "Attack",
			"level1": 1,
			
		}
		
	}
