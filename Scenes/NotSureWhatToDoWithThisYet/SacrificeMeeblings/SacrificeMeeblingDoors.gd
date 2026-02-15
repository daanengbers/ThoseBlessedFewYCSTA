extends Node2D


@export var amountToSac = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func SacrificeOption():
	var testamountofmeeblingsalive = get_tree().get_nodes_in_group("crowd_m").size()
	if amountToSac < testamountofmeeblingsalive:
		$UI/SacrificeMeeblingScreen/MeeblingSacText.text = str("Sacrifice" + str(amountToSac) + "Meeblings?")
		$UI/SacrificeMeeblingScreen.spawncards(125)
		$UI/SacrificeMeeblingScreen.spawncards(195)
		##HERE IT SHOULD SPAWN AN OPTION FOR YES OR NO
		pass
	if amountToSac >= testamountofmeeblingsalive:
		##HERE IT SHOULD SPAWN AN OPTION FOR ONLY NO
		pass

func Sacrifice():
	var meeblings = get_tree().get_nodes_in_group("crowd_m")
	if amountToSac == 1:
		meeblings[0].queue_free()
	if amountToSac == 2:
		meeblings[0].queue_free()
		meeblings[1].queue_free()
	if amountToSac == 3:
		meeblings[0].queue_free()
		meeblings[1].queue_free()
		meeblings[2].queue_free()
	

func _on_activate_options_area_entered(area):
	SacrificeOption()
	pass # Replace with function body.
