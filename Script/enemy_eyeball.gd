extends CharacterBody2D

var EXPORB = preload("res://Scenes/exp_area.tscn")
var EXPLOSION = preload("res://Scenes/bloodexplosion.tscn")

@export var SPEED = 20
var SpeedBoostOfScreen = 0
@export var canflip = false

@onready var e_anim = $Icon/Anim

@export var hp = 40
var alive = true

var randomspeedextra = 0

var dist_to_crowdm
var crowd_members
var nearest_crowdm
var withinreach = false
var startedexploding = false

func _ready():
	randomize()
	randomspeedextra = randi()%10
	e_anim.play("bounce")
	$EffectsAnim.play("default")
	$Healthbar.max_value = hp
	$Healthbar.value = hp

func _physics_process(_delta):
	
	move_and_slide()

func update_meeblingsandmovement():
	crowd_members = get_tree().get_nodes_in_group("crowd_m")
	if crowd_members.size() >= 1:
		nearest_crowdm = crowd_members[0]
	
		for mem in crowd_members:
			if mem.global_position.distance_to(self.global_position) < nearest_crowdm.global_position.distance_to(self.global_position):
				nearest_crowdm = mem
		
		dist_to_crowdm = abs(global_position - nearest_crowdm.global_position)
		
		$Rot.look_at(nearest_crowdm.global_position)
		
		if (dist_to_crowdm.x > 20 or dist_to_crowdm.y > 20) && startedexploding == false:
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
		
		if withinreach == true && startedexploding == false:
			startexploding()
			
			
			#nearest_crowdm.hp -= 1
			#nearest_crowdm.hurt()
			#if nearest_crowdm.hp <= 0:
			#	nearest_crowdm.kill()
		speedboost()

func speedboost():
	var crowd_simulator = get_tree().get_nodes_in_group("crowd_p")
	var dist_to_crowdsim = abs(global_position - crowd_simulator[0].global_position)
	if dist_to_crowdsim.x > 380 or dist_to_crowdsim.y > 180:
		SpeedBoostOfScreen = 200
	else: 
		SpeedBoostOfScreen = 0

func startexploding():
	startedexploding = true
	e_anim.play("explodestartup")

func explode():
	var expl = EXPLOSION.instantiate()
	get_parent().add_child.call_deferred(expl)
	expl.position = global_position
	kill()

func hurt():
	$EffectsAnim.play("hurt")
	$Sounds/HurtSound.play()
	$Healthbar.visible = true
	$Healthbar.value = hp

func apply_freeze():
	SPEED = 10
	$Icon.self_modulate = Color(0,1,1)

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
