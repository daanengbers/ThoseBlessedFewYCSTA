extends Node2D

var page = 0
var vischars = 0

func _process(delta):
	if vischars < 160:
		vischars += 1
		$Explanation.visible_characters = vischars
	if Input.is_action_just_pressed("spell1") or Input.is_action_just_pressed("spell2") or Input.is_action_just_pressed("spell3") or Input.is_action_just_pressed("spell4"):
		vischars = 0
		$Explanation.visible_characters = vischars
		advance_text()

func advance_text():
	vischars = 0
	page += 1
	$Expl_progress.value = page
	if page == 1:
		$Pages/Page01.visible = true
		$Explanation.set_text('In this game, the goal is to build an army of "Meeblings" and defeat as many foes as possible.')
	if page == 2:
		$Pages/Page01.visible = false
		$Pages/Page02.visible = true
		if Globalsettings.global_controllertype == "Keyboard":
			$Explanation.set_text('You control the big arrow with the arrow keys or WASD. All Meeblings will automatically follow it.')
		if Globalsettings.global_controllertype == "Gamepad":
			$Explanation.set_text('You control the big arrow with the left stick on your controller. All Meeblings will automatically follow it.')
	if page == 3:
		$Pages/Page02.visible = false
		$Pages/Page03.visible = true
		$Explanation.set_text('You will start off with a few Meeblings, but you can gain more by freeing Meeblings from cages.')
	if page == 4:
		$Pages/Page03.visible = false
		$Pages/Page04.visible = true
		$Explanation.set_text('Meeblings will automatically target the nearest enemy.')
	if page == 5:
		$Pages/Page04.visible = false
		$Pages/Page05.visible = true
		$Explanation.set_text('Enemies will drop XP once defeated. Meeblings can collect this XP to level up.')
	if page == 6:
		$Pages/Page05.visible = false
		$Pages/Page06.visible = true
		$Explanation.set_text('When you level up, you can choose between 3 cards with random upgrades, spells, or other.')
	if page == 7:
		$Pages/Page06.visible = false
		$Pages/Page07.visible = true
		$Explanation.set_text('Upgrades increase your stats, such as Attack power, Move speed, Cooldown reduction, Bullet amount and Health.')
	if page == 8:
		$Pages/Page07.visible = false
		$Pages/Page08.visible = true
		$Explanation.set_text('Spells give you access to more powerful attacks, but you need to wait for a cooldown to use them again.')
	if page == 9:
		$Pages/Page08.visible = false
		$Pages/Page09.visible = true
		if Globalsettings.global_controllertype == "Keyboard":
			$Explanation.set_text('Use spells by pressing G, H, V or B, depending on which button you assigned the spell to.')
			$Pages/Page09/Keyboard.visible = true
		if Globalsettings.global_controllertype == "Gamepad":
			$Explanation.set_text('Use spells by pressing one of the 4 face buttons, depending on which button you assigned the spell to.')
			$Pages/Page09/Gamepad.visible = true
	if page == 10:
		$Pages/Page09.visible = false
		$Pages/Page10.visible = true
		$Explanation.set_text('There are many areas around the map to explore. Be careful of the dangerous terrain and strong enemies.')
	if page == 11:
		$Explanation.set_text('Be blessed player...')
	if page == 12:
		get_tree().change_scene_to_file("res://Scenes/new_titlescreen.tscn")
	
