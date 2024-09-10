extends Node2D

# Weenter Approved (Great Cleanup, 9-9-24)

func _process(_delta):
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://Scenes/new_titlescreen.tscn")
