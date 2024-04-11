extends Area2D

@export var expamount = 20
@export var meeblingsoul = false

func _ready():
	$Sprite/Anim.play("play")
	if meeblingsoul == true:
		$Deathsound.play()

func _process(delta):
	pass

func _on_timer_timeout():
	$box.set_deferred("disabled", false)
