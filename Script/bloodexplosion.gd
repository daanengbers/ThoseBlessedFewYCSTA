extends Area2D

var damage = 5

func _ready():
	$Bloodsplatter.emitting = true
	$Coloranim.play("fade")

func _on_area_entered(area):
	if area.get_parent().is_in_group("crowd_m"):
		area.get_parent().hp -= damage
		area.get_parent().hurt()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()

func _on_hitbox_timer_timeout():
	$box.set_deferred("disabled", true)
