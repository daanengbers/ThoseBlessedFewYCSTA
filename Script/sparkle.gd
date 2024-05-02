extends Node2D

func _ready():
	$Shines.emitting = true
	$Sparkles.emitting = true

func _on_timer_timeout():
	queue_free()
