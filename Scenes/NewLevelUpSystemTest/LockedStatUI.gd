extends Sprite2D

var lvlText
var statText

var firstTimeCalled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	lvlText = $LVLText
	statText = $StatText
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateUI(lvl, stat):
	if firstTimeCalled == true:
		statText.visible = true
		lvlText.visible = true
		lvlText.set_text(lvl)
		statText.set_text(stat)
	else:
		lvlText.visible = true
	pass
