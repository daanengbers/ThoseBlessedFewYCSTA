extends Node2D

# Script for the number that appears above enemies whenever they take damage
# Weenter Approved (Great Cleanup, 10-9-24)

var dmg_value = 0

func _ready():
	# Set damage value and animation
	$Container/Text.set_text(str(dmg_value))
	$Container/Anim.play("appear")
	# Set value color
	if dmg_value >= 10 && dmg_value <= 19:
		modulate = Color(1,1,.8)
	elif dmg_value >= 20 && dmg_value <= 29:
		modulate = Color(1,1,.5)
	elif dmg_value >= 30 && dmg_value <= 39:
		modulate = Color(1,.8,.3)
	elif dmg_value >= 40 && dmg_value <= 49:
		modulate = Color(1,.4,.1)
	elif dmg_value >= 50:
		modulate = Color(1,.2,0)

# Signals -----

func _on_timer_timeout():
	queue_free()
