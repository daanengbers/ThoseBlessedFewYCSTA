extends Area2D

var stageuntildespawn = 10
var randomid = 0
@export var expamount = 1
var pickedup = false

func _ready():
	set_as_top_level(true)
	randomize()
	randomid = randi()%9999 + 1
	if expamount < 5:
		$Sprite/Anim.play("level_1")
	if expamount >= 5 && expamount < 20:
		$Sprite/Anim.play("level_2")
	if expamount >= 20 && expamount < 100:
		$Sprite/Anim.play("level_3")
	if expamount >= 100 && expamount < 500:
		$Sprite/Anim.play("level_4")
	if expamount >= 500:
		$Sprite/Anim.play("level_5")
	

func subtract_despawn():
	stageuntildespawn -= 1
	if stageuntildespawn <= 0:
		modulate = Color(1,1,1,.5)
	#	queue_free()

func _on_area_entered(area):
	if area.is_in_group("EXPorb"):
		if area.expamount < expamount:
			expamount += area.expamount
			stageuntildespawn = 10
			area.queue_free()
		else:
			if area.randomid < randomid:
				expamount += area.expamount
				stageuntildespawn = 10
				area.queue_free()
			else:
				pass
		if expamount < 5:
			$Sprite/Anim.play("level_1")
		if expamount >= 5 && expamount < 20:
			$Sprite/Anim.play("level_2")
		if expamount >= 20 && expamount < 100:
			$Sprite/Anim.play("level_3")
		if expamount >= 100 && expamount < 500:
			$Sprite/Anim.play("level_4")
		if expamount >= 500:
			$Sprite/Anim.play("level_5")
		#if expamount < area.expamount:
		#	area.expamount += expamount
		#	area.stageuntildespawn = 10
		#	queue_free()
		#else:
		#	if randomid < area.randomid:
		#		area.expamount += expamount
		#		area.stageuntildespawn = 10
		#		queue_free()
		#	else:
		#		pass
	if area.get_parent().is_in_group("meeblings") && pickedup == false:
		pickedup = true
		$Sprite/Anim.play("pickup")
		$box.set_deferred("disabled", true)
		$XPTimer.start()
		
	


func _on_xp_timer_timeout():
	Globalsettings.global_xp += expamount
	Globalsettings.global_total_xp += expamount
	queue_free()
