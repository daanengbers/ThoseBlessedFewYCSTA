extends BasicAttackBase
class_name DefaultBasicAttack

## Default basic attack — 1:1 scaling on everything

func _ready() -> void:
	baseCooldown = 1.0
	baseDamage = 5.0
	damageScaling = 1.0
	attackSpeedScaling = 1.0
	amountScaling = 1.0
	bounceScaling = 1.0
	lifeDrainScaling = 1.0
	projectileScene = GameResources.baseBulletScene
