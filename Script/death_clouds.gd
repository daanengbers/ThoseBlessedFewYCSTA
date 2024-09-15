extends Node2D

# Script for the damaging clouds which can be tiled.
# Weenter In-Progess (Great Cleanup, 11-9-24) - Hitbox missing

# Issues:
# No damage is currently done when a Meebling interacts with these posion clouds.

func _ready():
	# Set animation to default
	$CloudAnim.play("danger")
