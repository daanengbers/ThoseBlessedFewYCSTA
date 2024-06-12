extends Area2D

var stageuntildespawn = 10
var randomid = 0
@export var expamount = 20
@export var meeblingsoul = false

func _ready():
	randomize()
	randomid = randi()%9999 + 1
	$Sprite/Anim.play("play")
	if meeblingsoul == true:
		$Deathsound.play()
	$Soulparticles.emitting = true
	$Glassparticles.emitting = true

func _process(_delta):
	pass

func _on_timer_timeout():
	$box.set_deferred("disabled", false)

func _on_area_entered(area):
	if area.get_parent().is_in_group("crowd_m"):
		Globalsettings.global_xp += expamount
		Globalsettings.global_total_xp += expamount
		queue_free()
	#if area.is_in_group("EXPorb"):
	#	if expamount < area.expamount:
	#		area.expamount += expamount
	#		area.stageuntildespawn = 10
	#		queue_free()
	#	else:
	#		pass
