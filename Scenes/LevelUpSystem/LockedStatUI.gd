extends Sprite2D

var lvlText
var statText
var statIcon

var firstTimeCalled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	lvlText = $LVLText
	statText = $StatText
	statIcon = $Icon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateUI(lvl, FrameNmr):
	if firstTimeCalled == true:
		##statText.visible = true
		statIcon.visible = true
		lvlText.visible = true
		lvlText.set_text(lvl)
		statIcon.set_frame(FrameNmr)
		firstTimeCalled = false
	else:
		lvlText.set_text(lvl)
		lvlText.visible = true
	pass
