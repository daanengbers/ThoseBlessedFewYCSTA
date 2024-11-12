extends CharacterBody2D

var EXPORB = preload("res://Scenes/exp_area.tscn")

@export var SPEED = 40
var SpeedBoostOfScreen = 0
@export var hp = 2000
var damage = 3

@onready var e_anim = $Icon/Anim

var alive = true

var chasestate = "sleeping"



# var dist_to_crowdm # !!!!! IRELLEVANT CODE
var crowd_members
var nearest_crowdm
var withinreach = false

func _ready():
	# Set default animations and values
	e_anim.play("sleep")
	$EffectsAnim.play("default")
	$UI/Healthbar.max_value = hp

func _physics_process(_delta):
	
	move_and_slide()

# Functions -----

func updateMeeblingsAndMovement():
	crowd_members = get_tree().get_nodes_in_group("crowd_m")
	if crowd_members.size() >= 1:
		nearest_crowdm = crowd_members[0]
	
	for mem in crowd_members:
		if mem.global_position.distance_to(self.global_position) < nearest_crowdm.global_position.distance_to(self.global_position):
			nearest_crowdm = mem
	
	# dist_to_crowdm = abs(global_position - nearest_crowdm.global_position) # !!!!! IRELLEVANT CODE
	
	$Rot.look_at(nearest_crowdm.global_position)
	
	#if dist_to_crowdm.x > 20 or dist_to_crowdm.y > 20: # !!!!! IRELLEVANT CODE
	if chasestate == "chasing":
		velocity = Vector2(SPEED, 0).rotated($Rot.rotation)
	#withinreach = false 								# !!!!! IRELLEVANT CODE
	#else: 												# !!!!! IRELLEVANT CODE
	#	velocity.x = 0 									# !!!!! IRELLEVANT CODE
	#	velocity.y = 0 									# !!!!! IRELLEVANT CODE
	#	withinreach = true 								# !!!!! IRELLEVANT CODE
	speedboost()

func speedboost():
	var crowd_simulator = get_tree().get_nodes_in_group("crowd_p")
	var dist_to_crowdsim = abs(global_position - crowd_simulator[0].global_position)
	if dist_to_crowdsim.x > 380 or dist_to_crowdsim.y > 180:
		SpeedBoostOfScreen = 200
	else: 
		SpeedBoostOfScreen = 0

func wakeup():
	chasestate = "waking"
	$Icon/Anim.play("wake")

func startbossfight():
	$UI.visible = true
	Globalsettings.bossfight_active = true
	Globalsettings.globalmusic = 2
	Globalsettings.setmusic()

func startchasing():
	chasestate = "chasing"
	$Icon/Anim.play("bounce")

func activateshurikens():
	$RotateHitboxes/Anim.play("start")
	$RotateHitboxes/HurtAREA01/Sprite/Anim.play("spin")
	$RotateHitboxes/HurtAREA02/Sprite/Anim.play("spin")

func rotateshurikens():
	$RotateHitboxes/Anim.play("rotate")

func hurt():
	$EffectsAnim.play("hurt")
	$UI/Healthbar.value = hp

func apply_freeze():
	SPEED = 20
	$Icon.self_modulate = Color(0,1,1)

func kill():
	Onscreenmessages.displaymessage("Boss Defeated")
	Globalsettings.bossfight_active = false
	Globalsettings.globalmusic = 1
	Globalsettings.setmusic()
	alive = false
	spawn_exporb()
	queue_free()

func spawn_exporb():
	var ex = EXPORB.instantiate()
	get_parent().add_child.call_deferred(ex)
	ex.position = global_position
	ex.expamount = 200

func _on_visible_on_screen_notifier_2d_screen_entered():
	if Globalsettings.bossfight_active == false:
		wakeup()

func _on_hurt_area_01_area_entered(area):
	if area.get_parent().is_in_group("crowd_m"):
		area.get_parent().hp -= damage
		area.get_parent().hurt()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()
