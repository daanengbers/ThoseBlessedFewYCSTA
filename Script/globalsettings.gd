extends Node

var globalmusic = 1
var global_Musicvol = 1
var global_SFXvol = 1
#var bus_name: String
#var bus_index: int
var global_controllertype = "Keyboard"
var global_arrow = 1
var global_showfps = false
var global_fullscreen = true

var global_xp = 0
var global_total_xp = 0
var highscore_xp = 0

var currentrun_extraattack = 0
var currentrun_extraspeed = 0
var currentrun_minuscooldown = 0
var currentrun_extrabullets = 0
var currentrun_extrahealth = 0

var timerrunning = false
var g_seconds = 0
var g_uisecconds = 0
var g_uiminutes = 0

var g_enemiesAlive = 0

var g_spell1 = 0
var g_spell2 = 0
var g_spell3 = 0
var g_spell4 = 0

var bossfight_active = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#bus_index = AudioServer.get_bus_index(bus_name)

func _process(_delta):
	
	# Gray this out before release:
	g_enemiesAlive = get_tree().get_nodes_in_group("enemy_m").size()
	
	if globalmusic == 1:
		if $Normalmusic.playing == false:
			$Normalmusic.play()
	if globalmusic == 2:
		if $Bossmusic.playing == false:
			$Bossmusic.play()

func setmusic():
	$Normalmusic.stop()
	$Bossmusic.stop()

func resetrun():
	global_xp = 0
	global_total_xp = 0
	currentrun_extraattack = 0
	currentrun_extraspeed = 0
	currentrun_minuscooldown = 0
	currentrun_extrabullets = 0
	currentrun_extrahealth = 0
	g_spell1 = 0
	g_spell2 = 0
	g_spell3 = 0
	g_spell4 = 0
	g_seconds = 0
	g_uisecconds = 0
	g_uiminutes = 0

func _on_game_timer_timeout():
	if timerrunning == true:
		if get_tree().paused == false:
			g_seconds += 1
			g_uisecconds +=1 
			if g_uisecconds == 60:
				g_uiminutes += 1
				g_uisecconds = 0
	$Timers/GameTimer.start()

func _on_despawn_timer_timeout():
	if get_tree().paused == false:
		for des in get_tree().get_nodes_in_group("Despawn"):
			des.subtract_despawn()
	$Timers/DespawnTimer.start()
