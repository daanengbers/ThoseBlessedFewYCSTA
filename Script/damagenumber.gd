extends Node2D

var dmg_value = 0

func _ready():
	$Container/Text.set_text(str(dmg_value))
	$Container/Anim.play("appear")
	if dmg_value >= 10:
		modulate = Color(1,1,.8)
	elif dmg_value >= 20:
		modulate = Color(1,1,.5)
	elif dmg_value >= 30:
		modulate = Color(1,.8,.3)
	elif dmg_value >= 40:
		modulate = Color(1,.4,.1)
	elif dmg_value >= 50:
		modulate = Color(1,.2,0)
	
	

func _on_timer_timeout():
	queue_free()
