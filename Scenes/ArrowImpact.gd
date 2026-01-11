extends Node2D
@export var damage = 5
@onready var animator = $ArrowImpactAnimator

func _ready():
	set_as_top_level(true)
	animator.play("Impact")
	cleanAfterAnim()

func cleanAfterAnim():
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _on_arrow_area_area_entered(area):
	if area.get_parent().is_in_group("meeblings"):
		area.get_parent().hp -= damage
		area.get_parent().hurt()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()
