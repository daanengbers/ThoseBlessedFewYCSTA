extends Area2D

var stageuntildespawn = 10
var randomid = 0
@export var expamount = 1

func _ready():
	randomize()
	randomid = randi()%9999 + 1
	$Sprite/Anim.play("play")

func subtract_despawn():
	stageuntildespawn -= 1
	if stageuntildespawn <= 0:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("EXPorb"):
		if expamount < area.expamount:
			area.expamount += expamount
			area.stageuntildespawn = 10
			queue_free()
		else:
			if randomid < area.randomid:
				area.expamount += expamount
				area.stageuntildespawn = 10
				queue_free()
			else:
				pass
	if area.get_parent().is_in_group("crowd_m"):
		Globalsettings.global_xp += expamount
		queue_free()
