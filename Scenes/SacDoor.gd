extends Area2D

@export var amountToSac = 1
@export var isCleared = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isCleared == true:
		isCleared = false
		$".".queue_free()
		pass
	pass
