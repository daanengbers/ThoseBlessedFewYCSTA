extends CharacterBody2D

var EXPORB = preload("res://Scenes/exp_area.tscn")

@export var SPEED = 20
@export var canflip = false

@onready var e_anim = $Icon/Anim

@export var hp = 24
var alive = true

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
	$Healthbar.max_value = hp
	$Healthbar.value = hp
	update_meeblingsandmovement()

func _physics_process(_delta):
	
	move_and_slide()

func update_meeblingsandmovement():
	crowd_members = get_tree().get_nodes_in_group("crowd_m")
	nearest_crowdm = crowd_members[0]
	
	for mem in crowd_members:
		if mem.global_position.distance_to(self.global_position) < nearest_crowdm.global_position.distance_to(self.global_position):
			nearest_crowdm = mem
	
	dist_to_crowdm = abs(global_position - nearest_crowdm.global_position)
	
	$Rot.look_at(nearest_crowdm.global_position)
	
	if dist_to_crowdm.x > 14 or dist_to_crowdm.y > 14:
		velocity = Vector2(SPEED + randomspeedextra, 0).rotated($Rot.rotation)
		withinreach = false
	else:
		velocity.x = 0
		velocity.y = 0
		withinreach = true
	
	if withinreach == true:
		nearest_crowdm.hp -= 1
		nearest_crowdm.hurt()
		if nearest_crowdm.hp <= 0:
			nearest_crowdm.kill()

func hurt():
	$EffectsAnim.play("hurt")
	$HurtSound.play()
	$Healthbar.value = hp

func kill():
	alive = false
	spawn_exporb()
	queue_free()

func spawn_exporb():
	var ex = EXPORB.instantiate()
	get_parent().add_child.call_deferred(ex)
	ex.position = global_position

func _on_update_timer_timeout():
	update_meeblingsandmovement()
	$Timers/UpdateTimer.start()
