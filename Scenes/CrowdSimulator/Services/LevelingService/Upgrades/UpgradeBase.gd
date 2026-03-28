extends Node
class_name UpgradeBase

enum UpgradeType {Stat, Ability}

@export var upgradeType : UpgradeType = UpgradeType.Stat
@export var cardName : String
@export var description: Array[String]
@export var spriteFrame: int
@export var maxLevel: int

var currentLevel : int = 0

func IsOwned() -> bool:
	return currentLevel > 0

func CanUpgrade() -> bool:
	return currentLevel < maxLevel

func GetNextLevel() -> int:
	return currentLevel + 1

