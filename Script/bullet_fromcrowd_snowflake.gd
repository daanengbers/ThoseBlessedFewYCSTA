extends RigidBody2D

# Script for frost flake projectile spawned by Meebling
# Weenter In-Progess (Great Cleanup, 9-10-24) - Change apply freeze

# Issues:
# Change "apply_freeze" to "applyFreeze" once all enemies have their script optimized

# Preload variables
var DMGVAL = preload("res://Scenes/damagenumber.tscn")

@export var damage = 0
@export var destroyonimpact = false

func _ready():
	pass

# Functions -----

func hitImpact():
	queue_free()

func spawnDamageValue():
	var dv = DMGVAL.instantiate()
	get_parent().get_parent().add_child.call_deferred(dv)
	dv.position = global_position
	dv.dmg_value = damage

# Signals -----

func _on_queue_timer_timeout():
	queue_free()

func _on_hitbox_bullet_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		area.get_parent().hp -= (damage)
		area.get_parent().hurt()
		area.get_parent().apply_freeze()
		#spawnDamageValue()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()
		if destroyonimpact == true:
			hitImpact()
