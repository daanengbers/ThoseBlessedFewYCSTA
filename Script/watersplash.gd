extends Node2D

func _ready():
	set_as_top_level(true)
	$Sprite/Anim.play("splash")
	$Upsplashes.emitting = true

func _on_queue_timer_timeout():
	queue_free()
