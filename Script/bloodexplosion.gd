extends Area2D

# Script for blood explosion that spawns once an eyeball enemy has exploded.
# Weenter Approved (Great Cleanup, 10-9-24)

var damage = 5

func _ready():
	# Start animations and sound
	$Bloodsplatter.emitting = true
	$Coloranim.play("fade")
	$Splat.play()
	
	set_as_top_level(true)

# Signals -----

func _on_area_entered(area):
	if area.get_parent().is_in_group("meeblings"):
		area.get_parent().hp -= damage
		area.get_parent().hurt()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()

func _on_hitbox_timer_timeout():
	$box.set_deferred("disabled", true)
