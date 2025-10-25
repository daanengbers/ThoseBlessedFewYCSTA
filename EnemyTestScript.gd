extends CharacterBody2D
var quadrantToAttack

var meeblings
# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	randomize()
	quadrantToAttack = randi_range(1,4)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	walkTowardsMeebs()

func walkTowardsMeebs():
	randomize()
	var speed = randi_range(20,50)
	match quadrantToAttack:
		1:
			$Rot.look_at(Globalsettings.globalClosestMeeblingQ1.global_position)
		2:
			$Rot.look_at(Globalsettings.globalClosestMeeblingQ2.global_position)
		3:
			$Rot.look_at(Globalsettings.globalClosestMeeblingQ3.global_position)
		4:
			$Rot.look_at(Globalsettings.globalClosestMeeblingQ4.global_position)
	velocity = Vector2(speed, 0).rotated($Rot.rotation)
	move_and_slide()
