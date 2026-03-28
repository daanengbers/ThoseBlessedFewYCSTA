extends CharacterBody2D

var speed = 80
var speedmultiplier = 1

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		velocity.x = -speed * speedmultiplier
	elif Input.is_action_pressed("right"):
		velocity.x = speed * speedmultiplier
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("up"):
		velocity.y = -speed * speedmultiplier
	elif Input.is_action_pressed("down"):
		velocity.y = speed * speedmultiplier
	else:
		velocity.y = 0
	
	if Input.is_action_pressed("aim"):
		speedmultiplier = 2.5
	else:
		speedmultiplier = 1
	
	move_and_slide()
