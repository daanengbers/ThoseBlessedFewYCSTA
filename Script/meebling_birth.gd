extends Node2D

var MEEB = preload("res://Scenes/crowd_member.tscn")

func _ready():
	$Anim.play("birth")
	$Particles.emitting = true

func spawnmeebling():
	var me = MEEB.instantiate()
	#get_parent().add_child.call_deferred(me)
	get_parent().get_node("Ysorter").add_child.call_deferred(me)
	me.position = global_position
	$Particles.emitting = false
	$Spawnsound.play()
