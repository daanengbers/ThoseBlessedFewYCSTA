extends UpgradeBase
class_name StatUpgrade

@export var levels: Array[int] = []
@export var slot: int = -1

func _ready() -> void:
	upgradeType = UpgradeType.Stat
	if maxLevel <= 0:
		maxLevel = levels.size()

func ApplyStatLevel() -> void:
	# increase level
	currentLevel += 1
	# apply effect based on levels array, etc.
