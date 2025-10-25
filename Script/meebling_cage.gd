extends StaticBody2D

var MEEBLING = preload("res://Scenes/crowd_member.tscn")

@onready var c_anim = $Sprites/Anim

var alive = true
var spawnedmeebling = false
@export var hp = 80
@export var meeblingscaught = 1
var on_screen = false

func _ready():
	$Healthbar.max_value = hp
	$Healthbar.value = hp
	
	c_anim.play("RESET")

func hurt():
	
	$ChipSound.play()
	c_anim.play("RESET")
	c_anim.play("hurt")
	$Healthbar.visible = true
	$Healthbar.value = hp

func apply_freeze():
	pass

func spawnmeebling():
	var arrow = get_tree().get_first_node_in_group("CrowdSimulation")
	arrow.birthMeebling(global_position)
	#var me = MEEBLING.instantiate()
	#get_parent().add_child.call_deferred(me)
	#me.position.x = global_position.x + randi()%20 -10
	#me.position.y = global_position.y + randi()%20 -10

func kill():
	alive = false
	#$Colbox.set_deferred("disabled", true)
	$HURTbox_Enemy/box.set_deferred("disabled", true)
	$Sprites/Captive.visible = false
	$Sprites/BackBones.visible = false
	$Sprites/Dome.visible = false
	$Healthbar.visible = false
	$BreakSound.play()
	if spawnedmeebling == false:
		spawnedmeebling = true
		spawnmeebling()
	remove_from_group("enemy_m")


func _on_visible_on_screen_notifier_2d_screen_entered():
	if on_screen == false && alive == true:
		on_screen = true
		$HURTbox_Enemy/box.set_deferred("disabled", false)
