extends Node2D

func _ready():
	$UI/Message/Anim.play("RESET")

func displaymessage(msg_text):
	$UI/Message.set_text(msg_text)
	$UI/Message/Anim.play("appear")
