extends CharacterBody2D

var EXPORB = preload("res://Scenes/exp_area.tscn")
var AOE = preload("res://Scenes/enemy_aoe.tscn")

@export var SPEED = 20
@export var canflip = false

#@onready var e_anim = $Icon/Anim
@onready var helmet = $Sprites/Helmet
@onready var torso = $Sprites/Body
@onready var blade = $Sprites/Blade

@export var hp = 8000
var alive = true

@export var chasing = true

var randomspeedextra = 0

var dist_to_crowdm
var crowd_members
var nearest_crowdm
var withinreach = false
var attacking = false

func _ready():
	randomize()
	randomspeedextra = randi()%10
	#e_anim.play("bounce")
	#$EffectsAnim.play("default")
	$UI/Healthbar.max_value = hp
	$Sprites/Blade/BladePivotpoint/Swordanimation.play("idle")
	Globalsettings.bossfight_active = true
	Globalsettings.globalmusic = 2
	Globalsettings.setmusic()

func _physics_process(_delta):
	
	
	
	move_and_slide()

func update_meeblingsandmovement():
	crowd_members = get_tree().get_nodes_in_group("crowd_m")
	nearest_crowdm = crowd_members[0]
	
	for mem in crowd_members:
		if mem.global_position.distance_to(self.global_position) < nearest_crowdm.global_position.distance_to(self.global_position):
			nearest_crowdm = mem
	
	dist_to_crowdm = abs(global_position - nearest_crowdm.global_position)
	
	if attacking == false:
		$Rot.look_at(nearest_crowdm.global_position)
	if $Rot.rotation_degrees > 360:
		$Rot.rotation_degrees -= 360
	if $Rot.rotation_degrees < 0:
		$Rot.rotation_degrees += 360
	$TestLabel.set_text(str($Rot.rotation_degrees))
	if $Rot.rotation_degrees >= 337.5 or $Rot.rotation_degrees < 22.5:
		helmet.frame = 6
		torso.frame = 6
		blade.rotation_degrees = 270
	if $Rot.rotation_degrees >= 22.5 && $Rot.rotation_degrees < 67.5:
		helmet.frame = 7
		torso.frame = 7
		blade.rotation_degrees = 315
	if $Rot.rotation_degrees >= 67.5 && $Rot.rotation_degrees < 112.5:
		helmet.frame = 0
		torso.frame = 0
		blade.rotation_degrees = 0
	if $Rot.rotation_degrees >= 112.5 && $Rot.rotation_degrees < 157.5:
		helmet.frame = 1
		torso.frame = 1
		blade.rotation_degrees = 45
	if $Rot.rotation_degrees >= 157.5 && $Rot.rotation_degrees < 202.5:
		helmet.frame = 2
		torso.frame = 2
		blade.rotation_degrees = 90
	if $Rot.rotation_degrees >= 202.5 && $Rot.rotation_degrees < 247.5:
		helmet.frame = 3
		torso.frame = 3
		blade.rotation_degrees = 135
	if $Rot.rotation_degrees >= 247.5 && $Rot.rotation_degrees < 292.5:
		helmet.frame = 4
		torso.frame = 4
		blade.rotation_degrees = 180
	if $Rot.rotation_degrees >= 292.5 && $Rot.rotation_degrees < 337.5:
		helmet.frame = 5
		torso.frame = 5
		blade.rotation_degrees = 225
	
	
	if dist_to_crowdm.x > 20 or dist_to_crowdm.y > 20:
		if chasing == true && attacking == false:
			velocity = Vector2(SPEED + randomspeedextra, 0).rotated($Rot.rotation)
		withinreach = false
	else:
		velocity.x = 0
		velocity.y = 0
		withinreach = true



func swingattack():
	attacking = true
	velocity.x = 0
	velocity.y = 0
	$Sprites/Blade/BladePivotpoint/Swordanimation.play("swing")

func endattack():
	attacking = false
	$Sprites/Blade/BladePivotpoint/Swordanimation.play("idle")

func hurt():
	pass
	#$EffectsAnim.play("hurt")
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



func _on_update_timer_timeout():
	update_meeblingsandmovement()
	$Timers/UpdateTimer.start()

func _on_attack_timer_timeout():
	if dist_to_crowdm.x < 100 && dist_to_crowdm.y < 100:
		swingattack()
	$Timers/AttackTimer.start()
