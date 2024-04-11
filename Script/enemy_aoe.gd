extends Area2D


func _ready():
	$Anim.play("expand")

func _process(delta):
	pass


func _on_area_entered(area):
	if area.get_parent().is_in_group("crowd_m"):
		area.get_parent().hp -= 5


func _on_timer_timeout():
	queue_free()
