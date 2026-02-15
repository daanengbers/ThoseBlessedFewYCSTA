extends Sprite2D

var SKULL = preload("res://Scenes/enemy_skull.tscn")
var level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("Arrow"):
		$Area2D/TentAnim.play("TentOpen")
		await get_tree().create_timer(1.0).timeout
		spawnskullenemy()
		spawnskullenemy()
		spawnskullenemy()
		queue_free()
		pass # Replace with function body.

func spawnskullenemy():
	var sk = SKULL.instantiate()
	var randomtoporside = randi()%40 + 4
	get_parent().get_parent().get_parent().get_node("Ysorter").add_child.call_deferred(sk)
	sk.position.x = global_position.x + randomtoporside
	sk.position.y = global_position.y + randomtoporside
	sk.hp += level
