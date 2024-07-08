extends RigidBody2D

var DMGVAL = preload("res://Scenes/damagenumber.tscn")

@export var damage = 0
@export var destroyonimpact = false

func _ready():
	pass

func _on_queue_timer_timeout():
	queue_free()

func hitimpact():
	queue_free()

func spawndmgval():
	var dv = DMGVAL.instantiate()
	get_parent().get_parent().add_child.call_deferred(dv)
	dv.position = global_position
	dv.dmg_value = damage

func _on_hi_tbox_bullet_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		area.get_parent().hp -= (damage)
		area.get_parent().hurt()
		area.get_parent().apply_freeze()
		#spawndmgval()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()
		if destroyonimpact == true:
			hitimpact()
