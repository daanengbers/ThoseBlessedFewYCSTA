extends RigidBody2D

# Script for simple projectiles spawned by a Meebling. Includes basic bullet, fireball, thunder
# Weenter Approved (Great Cleanup, 10-9-24)

# Preload variables
var DMGVAL = preload("res://Scenes/damagenumber.tscn")

@export var damage = 5
@export var destroyonimpact = true

func _ready():
	pass

# Functions -----

func hitImpact():
	queue_free()

func spawnDamageValue():
	var dv = DMGVAL.instantiate()
	get_parent().get_parent().add_child.call_deferred(dv)
	dv.position = global_position
	dv.dmg_value = damage + Globalsettings.currentrun_extraattack

# Signals -----

func _on_queue_timer_timeout():
	queue_free()

func _on_hitbox_bullet_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		area.get_parent().hp -= (damage + Globalsettings.currentrun_extraattack)
		area.get_parent().hurt()
		spawnDamageValue()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()
		if destroyonimpact == true:
			hitImpact()
