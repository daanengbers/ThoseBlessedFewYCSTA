extends Node2D

var statID = "ATTACK"
var level = 0

var statToIncrease = "ATTACK"
var AmountToIncreaseDecrease = 5

var UI_Title = "ATTACK"
var UI_level = "1"
var NextCardUI_AmountToIncreaseDecrease = "+5"
var NextCardUI_Level = "1"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func levelUp():
	match level:
		1:
			AmountToIncreaseDecrease = 5
			##IncreaseStats(statToIncrease, AmountToIncreaseDecrease)
			
			UI_level = "1"
			NextCardUI_AmountToIncreaseDecrease = "+8"
			NextCardUI_Level = "2"
			pass
		2:
			AmountToIncreaseDecrease = 8
			##IncreaseStats(statToIncrease, AmountToIncreaseDecrease)
			
			UI_level = "2"
			NextCardUI_AmountToIncreaseDecrease = "+13"
			NextCardUI_Level = "3"
			pass
		3:
			
			pass
		4:
			
			pass
