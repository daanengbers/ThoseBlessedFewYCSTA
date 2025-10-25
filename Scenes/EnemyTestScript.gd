extends CharacterBody2D

var meeblings
# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	walkTowardsMeebs()

func walkTowardsMeebs():
	randomize()
	var speed = randi_range(20,50)
	meeblings = get_tree().get_nodes_in_group("meeblings")
	$Rot.look_at(meeblings[0].global_position)
	velocity = Vector2(speed, 0).rotated($Rot.rotation)
	move_and_slide()
