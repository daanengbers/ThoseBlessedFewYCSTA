extends Node2D

func _ready():
	cleanUp()

func cleanUp():
	$AnimationPlayer.play("CritEffect")
	await $AnimationPlayer.animation_finished
	queue_free()
	
