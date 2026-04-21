extends StatUpgrade
class_name AmountUpgrade

func ApplyStatLevel() -> void:
	##Up the current level
	currentLevel += 1
	
	##Apply the stat upgrade
	var levelValue = levels[currentLevel - 1]
	GlobalStats.globalStatsExtraAM += levelValue
