extends RigidBody2D

@export var damage = 5
@export var destroyonimpact = true

func _ready():
	set_as_top_level(true)

func _on_arrow_hurtbox_area_entered(area):
	##If a marked effect is hit, remove it
	if area.get_parent().is_in_group("markedEffect"):
		area.get_parent().clearOnHit()
	if area.get_parent().is_in_group("meeblings"):
		##Check if the meebling was marked, if so, increase damage and remove its marked status
		if area.get_parent().marked == true:
			var critEffect = GameResources.critEffectScene
			var critEffectIn = critEffect.instantiate()
			get_tree().current_scene.add_child(critEffectIn)
			critEffectIn.global_position = area.get_parent().global_position
			area.get_parent().marked = false
			area.get_parent().hp -= 20
			area.get_parent().hurt()
			queue_free()
		else:
			area.get_parent().hp -= damage
			area.get_parent().hurt()

func _on_duration_timer_timeout():
	queue_free()
