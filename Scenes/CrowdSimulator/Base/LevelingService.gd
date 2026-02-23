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

func GetXp(amount : int) -> void:
	pass

func LevelUp() -> void:
	pass

func LoadStats() -> void:
	statLibrary = {
		1: { ##Attack
			"cardName": "Attack",
			"level1": 1,
			
		}
		
	}
