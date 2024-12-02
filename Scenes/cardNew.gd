extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateCardUI(Title,Level,AmountToIncreaseDecrease, imageFrame, stat_ab_bon):
	##$eh/Spellcards.frame = cardcolor
	$eh/Cardname.set_text(str(Title))
	if Level == "":
		$eh/CardLevel.set_text("")
	else:
		if Level == "Recover":
			$eh/CardLevel.set_text("Recover")
		else:
			$eh/CardLevel.set_text("Level " + str(Level))
	$eh/Carddescription.set_text(str(AmountToIncreaseDecrease))
	$eh/UpgradeIcons.set_frame(imageFrame)
	$eh/Spellcards.frame = stat_ab_bon - 1
	##$eh/UpgradeIcons.frame = cardimg
	pass
	

func selectcardAnim():
	$eh/Anim.play("select")
	$eh/Select.play()
