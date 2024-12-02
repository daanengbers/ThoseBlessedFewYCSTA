extends CharacterBody2D

var EXPORB = preload("res://Scenes/exp_area.tscn")

@export var SPEED = 55
var SpeedBoostOfScreen = 0
@export var canflip = false

@onready var e_anim = $Icon/Anim

@export var hp = 10
var alive = true

var randomspeedextra = 0

var dist_to_crowdm
#var dist_to_crowdsim # !!!!!!!!!!! THIS LINE MIGHT CAUSE BUGS
var crowd_members
#var crowd_simulator # !!!!!!!!!!! THIS LINE MIGHT CAUSE BUGS
var nearest_crowdm
var withinreach = false
var amountOfMeebsInRange = 0

func _ready():
	randomize()
	randomspeedextra = randi()%10
	e_anim.play("bounce")
	$EffectsAnim.play("default")
	$Icon/Coloranim.play("fadein")
	$Healthbar.max_value = hp
	$Healthbar.value = hp
	update_meeblingsandmovement()

func _physics_process(_delta):
	
	move_and_slide()

func update_meeblingsandmovement():
	crowd_members = get_tree().get_nodes_in_group("crowd_m")
	if crowd_members.size() >= 1:
		nearest_crowdm = crowd_members[0]
		dist_to_crowdm = abs(global_position - nearest_crowdm.global_position)
	
		for mem in crowd_members:
			if mem.global_position.distance_to(self.global_position) < nearest_crowdm.global_position.distance_to(self.global_position):
				nearest_crowdm = mem
		
		$Rot.look_at(nearest_crowdm.global_position)
		
		match withinreach:
			true:
				nearest_crowdm.hp -= 1
				nearest_crowdm.hurt()
				velocity = Vector2(0,0)
				if nearest_crowdm.hp <= 0:
					nearest_crowdm.kill()
			false:
				velocity = Vector2(SPEED + SpeedBoostOfScreen + randomspeedextra, 0).rotated($Rot.rotation)
				
		
		speedboost()
	if crowd_members.size() <= 0:
		velocity = Vector2(0,40)

func speedboost():
	var crowd_simulator = get_tree().get_nodes_in_group("crowd_p")
	var dist_to_crowdsim = abs(global_position - crowd_simulator[0].global_position)
	if dist_to_crowdsim.x > 380 or dist_to_crowdsim.y > 180:
		SpeedBoostOfScreen = 200
	else: 
		SpeedBoostOfScreen = 0

func hurt():
	$EffectsAnim.play("hurt")
	$HurtSound.play()
	$Healthbar.value = hp
	$Healthbar.visible = true

func apply_freeze():
	SPEED = 15
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


func _on_hur_tbox_enemy_area_entered(area):
	if area.is_in_group("CrowdHurt"):
		amountOfMeebsInRange +=1
		withinreach = true

func _on_hur_tbox_enemy_area_exited(area):
	if area.is_in_group("CrowdHurt") && amountOfMeebsInRange > 0:
		amountOfMeebsInRange -= 1
	if area.is_in_group("CrowdHurt") && amountOfMeebsInRange == 0:
		withinreach = false

