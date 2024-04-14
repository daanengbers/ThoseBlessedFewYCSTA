extends CharacterBody2D

var EXPORB = preload("res://Scenes/exp_area.tscn")
var AOE = preload("res://Scenes/enemy_aoe.tscn")

@export var SPEED = 40
@export var canflip = false

@onready var e_anim = $Icon/Anim

@export var hp = 2000
var alive = true

@export var chasing = false

var randomspeedextra = 0

var dist_to_crowdm
var crowd_members
var nearest_crowdm
var withinreach = false

func _ready():
	randomize()
	randomspeedextra = randi()%10
	e_anim.play("bounce")
	$EffectsAnim.play("default")
	$UI/Healthbar.max_value = hp

func _physics_process(_delta):
	
	crowd_members = get_tree().get_nodes_in_group("crowd_m")
	nearest_crowdm = crowd_members[0]
	
	for mem in crowd_members:
		if mem.global_position.distance_to(self.global_position) < nearest_crowdm.global_position.distance_to(self.global_position):
			nearest_crowdm = mem
	
	dist_to_crowdm = abs(global_position - nearest_crowdm.global_position)
	
	$Rot.look_at(nearest_crowdm.global_position)
	
	if dist_to_crowdm.x > 20 or dist_to_crowdm.y > 20:
		if chasing == true:
			velocity = Vector2(SPEED + randomspeedextra, 0).rotated($Rot.rotation)
		withinreach = false
	else:
		velocity.x = 0
		velocity.y = 0
		withinreach = true
	
	if canflip == true:
		if velocity.x > 0:
			$Icon.flip_h = true
		else:
			$Icon.flip_h = false
	
	move_and_slide()

func hurt():
	$EffectsAnim.play("hurt")
	$UI/Healthbar.value = hp

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

func spawn_aoe():
	var ex = AOE.instantiate()
	get_parent().add_child.call_deferred(ex)
	ex.position = global_position

func _on_attack_timer_timeout():
	$AttackTimer.start()
	if withinreach == true:
		spawn_aoe()
		#nearest_crowdm.hp -= 1
		if nearest_crowdm.hp <= 0:
			nearest_crowdm.kill()


func _on_visible_on_screen_notifier_2d_screen_entered():
	if Globalsettings.bossfight_active == false:
		if chasing == false:
			$ChaseTimer.start()

func _on_chase_timer_timeout():
	chasing = true
	$UI.visible = true
	Globalsettings.bossfight_active = true
	Globalsettings.globalmusic = 2
	Globalsettings.setmusic()
