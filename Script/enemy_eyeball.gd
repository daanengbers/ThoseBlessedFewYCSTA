extends CharacterBody2D

var EXPORB = preload("res://Scenes/exp_area.tscn")

@export var SPEED = 20
@export var canflip = false

@onready var e_anim = $Icon/Anim

@export var hp = 10
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

func _physics_process(delta):
	
	crowd_members = get_tree().get_nodes_in_group("crowd_m")
	nearest_crowdm = crowd_members[0]
	
	for mem in crowd_members:
		if mem.global_position.distance_to(self.global_position) < nearest_crowdm.global_position.distance_to(self.global_position):
			nearest_crowdm = mem
	
	dist_to_crowdm = abs(global_position - nearest_crowdm.global_position)
	
	$Rot.look_at(nearest_crowdm.global_position)
	$Healthbar.value = hp
	
	if dist_to_crowdm.x > 14 or dist_to_crowdm.y > 14:
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
	
	$TestLabel.set_text(str(nearest_crowdm))
	
	move_and_slide()

func hurt():
	$EffectsAnim.play("hurt")
	$HurtSound.play()

func kill():
	alive = false
	spawn_exporb()
	queue_free()

func spawn_exporb():
	var ex = EXPORB.instantiate()
	get_parent().add_child.call_deferred(ex)
	ex.position = global_position

func _on_attack_timer_timeout():
	$AttackTimer.start()
	if withinreach == true:
		nearest_crowdm.hp -= 1
		nearest_crowdm.hurt()
		if nearest_crowdm.hp <= 0:
			nearest_crowdm.kill()
