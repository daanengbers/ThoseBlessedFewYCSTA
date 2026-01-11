extends Node2D

@onready var animator = $AnimationPlayer
var markedMeebling

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("IdleAnim")
	clearAfterTime(8.0)

func clearAfterTime(time:int):
	await get_tree().create_timer(time).timeout
	if markedMeebling != null:
		markedMeebling.marked = false
	queue_free()

func clearOnHit():
	queue_free()

func markMeebling(meeblingToMark):
	if meeblingToMark == null or not is_instance_valid(meeblingToMark):
		return
	meeblingToMark.marked = true
	markedMeebling = markedMeebling

func _on_marked_area_area_entered(area):
	if area.is_in_group("BossArrow"):
		##Explode
		pass
