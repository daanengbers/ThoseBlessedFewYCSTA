extends RigidBody2D

var DMGVAL = preload("res://Scenes/damagenumber.tscn")

@export var damage = 5
@export var destroyonimpact = true

func _ready():
	pass

func _process(delta):
	pass

func _on_queue_timer_timeout():
	queue_free()

func hitimpact():
	queue_free()

func spawndmgval():
	var dv = DMGVAL.instantiate()
	get_parent().get_parent().add_child.call_deferred(dv)
	dv.position = global_position
	dv.dmg_value = damage + Globalsettings.currentrun_extraattack

func _on_hi_tbox_bullet_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		area.get_parent().hp -= (damage + Globalsettings.currentrun_extraattack)
		area.get_parent().hurt()
		spawndmgval()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()
		if destroyonimpact == true:
			hitimpact()

