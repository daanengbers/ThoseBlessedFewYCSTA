extends Node2D

var TestArray = ["test", "Help", "Ligma"]
var Bounce = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func LookThroughArray():
	for i in TestArray.size():
		print(TestArray.size())
		print(i)
		print(TestArray[i])
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("aim"):
		LookThroughArray()
	pass
