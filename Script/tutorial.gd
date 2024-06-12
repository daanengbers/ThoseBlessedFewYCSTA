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
		$Explanation.set_text('In this game, the goal is to build an army of "Meeblings" and defeat as many foes as possible.')
	if page == 2:
		if Globalsettings.global_controllertype == "Keyboard":
			$Explanation.set_text('You control the big arrow with the arrow keys or WASD. All Meeblings will automatically follow it.')
		if Globalsettings.global_controllertype == "Gamepad":
			$Explanation.set_text('You control the big arrow with the left stick on your controller. All Meeblings will automatically follow it.')
	if page == 3:
		$Explanation.set_text('You will start off with a few Meeblings, but you can gain more by leveling up and freeing Meeblings from cages.')
	if page == 4:
		$Explanation.set_text('Meeblings will automatically target the nearest enemy.')
	if page == 5:
		$Explanation.set_text('Enemies will drop XP once defeated. Meeblings can collect this XP to level up.')
	if page == 6:
		$Explanation.set_text('When you level up, you can choose between 3 cards with random upgrades, spells, or other.')
	if page == 7:
		$Explanation.set_text('Upgrades increase your stats, such as Attack power, Move speed, Cooldown reduction, Bullet amount and Health.')
	if page == 8:
		$Explanation.set_text('Spells give you access to more powerful attacks, but you need to wait for a cooldown to use them again.')
	if page == 9:
		if Globalsettings.global_controllertype == "Keyboard":
			$Explanation.set_text('Use spells by pressing G, H, V or B, depending on which button you assigned the spell to.')
		if Globalsettings.global_controllertype == "Gamepad":
			$Explanation.set_text('Use spells by pressing one of the 4 face buttons, depending on which button you assigned the spell to.')
	if page == 10:
		$Explanation.set_text('There are many areas around the map to explore. Be careful of the dangerous terrain and strong enemies.')
	if page == 11:
		$Explanation.set_text('Be blessed player...')
	if page == 12:
		get_tree().change_scene_to_file("res://Scenes/new_titlescreen.tscn")
	
