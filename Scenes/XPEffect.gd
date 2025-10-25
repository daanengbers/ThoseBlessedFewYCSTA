extends Node2D

func _ready():
	set_as_top_level(true)

func playAnimAndKill():
	$AnimationPlayer.play("XpAdded")



func _on_timer_timeout():
	queue_free()
