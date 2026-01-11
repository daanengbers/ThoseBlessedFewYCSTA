extends Node2D

@onready var animator = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("IdleAnim")
	clearAfterTime(8.0)

func clearAfterTime(time:int):
	await get_tree().create_timer(time).timeout
	queue_free()

func _on_marked_area_area_entered(area):
	if area.is_in_group("BossArrow"):
		##Explode
		pass
