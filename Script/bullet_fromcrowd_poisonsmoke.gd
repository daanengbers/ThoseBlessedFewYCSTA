extends RigidBody2D

# Script for poison cloud spawned by Meebling
# Weenter Approved (Great Cleanup, 10-9-24)

# Preload variables
var DMGVAL = preload("res://Scenes/damagenumber.tscn")

@export var damage = 4
@export var destroyonimpact = true

func _ready():
	$Hitbox_BULLET/Anim.play("flicker")

# Functions -----

func spawnDamageValue():
	var dv = DMGVAL.instantiate()
	get_parent().get_parent().add_child.call_deferred(dv)
	dv.position = global_position
	dv.dmg_value = damage + Globalsettings.currentrun_extraattack

func stopEmitting():
	$CPUParticles2D.emitting = false

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
