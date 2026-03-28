extends StatUpgrade
class_name BounceUpgrade

func ApplyStatLevel() -> void:
	##Up the current level
	currentLevel += 1
	
	##Apply the stat upgrade
	var levelValue = levels[currentLevel - 1]
	Globalsettings.currentrun_extrabounce += levelValue
