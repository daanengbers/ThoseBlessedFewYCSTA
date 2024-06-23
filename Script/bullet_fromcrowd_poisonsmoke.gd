extends RigidBody2D

var DMGVAL = preload("res://Scenes/damagenumber.tscn")

@export var damage = 1
@export var destroyonimpact = true

func _ready():
	$HITbox_BULLET/Anim.play("flicker")

func spawndmgval():
	var dv = DMGVAL.instantiate()
	get_parent().get_parent().add_child.call_deferred(dv)
	dv.position = global_position
	dv.dmg_value = damage + Globalsettings.currentrun_extraattack

func stopemitting():
	$CPUParticles2D.emitting = false

func _on_queue_timer_timeout():
	queue_free()

func _on_hi_tbox_bullet_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		area.get_parent().hp -= (damage + Globalsettings.currentrun_extraattack)
		area.get_parent().hurt()
		spawndmgval()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()
