extends CharacterBody2D

# Script for Meebling, member of Meebling crowd.
# Weenter In-Progess (Great Cleanup, 9-9-24) - some optimization issues need to be fixed

# Issues:
# A lot of stuff in _physics_process(_delta) could be moved to crowd_simulation to save a ton of frame checks
# Meebling position updates calculate every frame. Is this too much?

# Preload variables
var BULLETINST = preload("res://Scenes/bullet_fromcrowd.tscn")
var SPARKLE = preload("res://Scenes/sparkle.tscn")
var FIREBALL = preload("res://Scenes/bullet_fromcrowd_fireball.tscn")
var THUNDERBOLT = preload("res://Scenes/bullet_fromcrowd_thunderbolt.tscn")
var POISON = preload("res://Scenes/bullet_fromcrowd_poisonsmoke.tscn")
var SNOW = preload("res://Scenes/bullet_fromcrowd_snowflake.tscn")
var DEADMEEBLY = preload("res://Scenes/exp_areameebling.tscn")
var DEADSPLASH = preload("res://Scenes/watersplash.tscn")

@onready var m_anim = $Meebling/Anim

const SPEED = 30

# var extradamage = 1 # !!!!! THIS VARIABLE MIGHT NOT BE NEEDED. DELETE LATER
# var extraspeed = 0  # !!!!! THIS VARIABLE MIGHT NOT BE NEEDED. DELETE LATER

var bulletamount = 1
var MAX_HP = 10 + Globalsettings.currentrun_extrahealth

var hp = 10
var alive = true
var falling = false
var fallingframes = 0

# THE NUMBER OF THE SPELL WHICH WILL RESET
var spellnumber = 0

var randomsprite = 0
var random_s = 0
@export var randomxplus = 0
@export var randomyplus = 0
var randomspeedextra = 0
var randomoffsetspace = 0

var max_cooldownframes = 100
var cooldownframes = 100

var crowdparent
var crowdp_pos = Vector2(0,0)
var dist_to_crowdp

# hit enemy variables
var enemy_members
var nearest_enemy
var withinreach = false
var currentextrabullets = 0

var IsIncapacitated = false


func _ready():
	
	# Randomize stats, sprites & shininess
	randomize()
	randomspeedextra = randi()%20 + 10 # previously 30 (?)
	if randomxplus == 0:
		randomxplus = randi()%70 - 35
	if randomyplus == 0:
		randomyplus = randi()%50 - 25
	randomoffsetspace = randi()%8
	randomsprite = randi()%8
	random_s = randi()%4096 + 1
	if random_s == 4096:
		randomsprite = 8
		spawnSparkle()
	$Meebling.frame = randomsprite
	
	# Set values & display to default
	hp = MAX_HP
	$Healthbar.max_value = MAX_HP
	
	# Set animations to default
	m_anim.play("bounce")
	
	# Find crowd parent (arrow)
	crowdparent = get_tree().get_nodes_in_group("crowd_p")

func _physics_process(_delta):
	
	# find crowd parent (arrow) location
	
	crowdp_pos.x = crowdparent[0].position.x + randomxplus
	crowdp_pos.y = crowdparent[0].position.y + randomyplus
	
	dist_to_crowdp = abs(global_position - crowdp_pos)
	
	if alive == true:
		
		# Bullet shooting
		
		if cooldownframes > 0:
			cooldownframes -= 1
		if cooldownframes == 0:
			currentextrabullets = Globalsettings.currentrun_extrabullets
			spawnBullet()
			cooldownframes = max_cooldownframes - Globalsettings.currentrun_minuscooldown
		
		# Spell inputs and spawning
		
		if Input.is_action_just_pressed("spell1") && crowdparent[0].spell1cooldown <= 0:
			spellnumber = 1
			if Globalsettings.g_spell1 == 0:
				pass
			if Globalsettings.g_spell1 == 1:
				spawnFireball()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell1 == 2:
				spawnThunder()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell1 == 3:
				spawnPoison()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell1 == 4:
				spawnSnowflake()
				$Timers/CooldownstartTimer.start()
		
		if Input.is_action_just_pressed("spell2") && crowdparent[0].spell2cooldown <= 0:
			spellnumber = 2
			if Globalsettings.g_spell2 == 0:
				pass
			if Globalsettings.g_spell2 == 1:
				spawnFireball()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell2 == 2:
				spawnThunder()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell2 == 3:
				spawnPoison()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell2 == 4:
				spawnSnowflake()
				$Timers/CooldownstartTimer.start()
		
		if Input.is_action_just_pressed("spell3") && crowdparent[0].spell3cooldown <= 0:
			spellnumber = 3
			if Globalsettings.g_spell3 == 0:
				pass
			if Globalsettings.g_spell3 == 1:
				spawnFireball()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell3 == 2:
				spawnThunder()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell3 == 3:
				spawnPoison()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell3 == 4:
				spawnSnowflake()
				$Timers/CooldownstartTimer.start()
		
		if Input.is_action_just_pressed("spell4") && crowdparent[0].spell4cooldown <= 0:
			spellnumber = 4
			if Globalsettings.g_spell4 == 0:
				pass
			if Globalsettings.g_spell4 == 1:
				spawnFireball()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell4 == 2:
				spawnThunder()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell4 == 3:
				spawnPoison()
				$Timers/CooldownstartTimer.start()
			if Globalsettings.g_spell4 == 4:
				spawnSnowflake()
				$Timers/CooldownstartTimer.start()
		
		# Look where to move towards and set velocity to direction (Movement)
		
		$Rot.look_at(crowdp_pos)
		
		if alive == true && falling == false && IsIncapacitated == false:
			if dist_to_crowdp.x > 12 + randomoffsetspace or dist_to_crowdp.y > 12 + randomoffsetspace:
				velocity = Vector2(SPEED + randomspeedextra + Globalsettings.currentrun_extraspeed, 0).rotated($Rot.rotation)
			else:
				velocity.x = 0
				velocity.y = 0
		
		if falling == true:
			velocity.y += 20
			fallingframes += 1
		
		move_and_slide()
		
		if $CliffWaterCollider.is_colliding():
			var collider = $CliffWaterCollider.get_collider()
			#print(collider)
			if alive == true:
				if collider.is_in_group("water_hiddentiles"):
					diefromwater()
				if collider.is_in_group("cliffs_hiddentiles"):
					falling = true
					if fallingframes == 1:
						velocity = Vector2(0,0)
				if collider.is_in_group("highwater_hiddentiles"):
					fallFromHigh()
		else:
			checkFallDamage()

# Functions -----

func checkAimShoot(): 
	enemy_members = get_tree().get_nodes_in_group("enemy_m")
	if enemy_members.size() >= 1:
		nearest_enemy = enemy_members[0]
	for mem in enemy_members:
		if mem.global_position.distance_to(self.global_position) < nearest_enemy.global_position.distance_to(self.global_position):
			nearest_enemy = mem
	if enemy_members.size() >= 1:
		if crowdparent[0].lockedin == false:
			$Rot2.look_at(nearest_enemy.global_position)
		else:
			$Rot2.look_at(crowdparent[0].aimring.global_position)

func checkFallDamage():
	falling = false
	if fallingframes >= 20 && fallingframes < 40:
		hp -= 1
		hurt()
	if fallingframes >= 40 && fallingframes < 60:
		hp -= 2
		hurt()
	if fallingframes >= 60 && fallingframes < 80:
		hp -= 4
		hurt()
	if fallingframes >= 80 && fallingframes < 100:
		hp -= 8
		hurt()
	if fallingframes >= 100 && fallingframes < 120:
		hp -= 16
		hurt()
	if fallingframes >= 120 && fallingframes < 140:
		hp -= 32
		hurt()
	if fallingframes >= 140:
		kill()
	if hp <= 0 && alive == true:
		kill()
	fallingframes = 0

# ----- Spawn seperate objects

func spawnBullet():
	checkAimShoot()
	$Sounds/Shoot.play()
	var bu = BULLETINST.instantiate()
	get_parent().add_child.call_deferred(bu)
	bu.position = global_position
	bu.apply_impulse(Vector2(200, 0).rotated($Rot2.rotation))
	bu.rotation = $Rot2.rotation
	if currentextrabullets > 0:
		$Timers/DoubleBulletTimer.start()
		currentextrabullets -= 1

func spawnFireball():
	checkAimShoot()
	$Sounds/Bigspell.play()
	var pr = FIREBALL.instantiate()
	get_parent().add_child.call_deferred(pr)
	pr.position = global_position
	pr.apply_impulse(Vector2(140, 0).rotated($Rot2.rotation))
	pr.rotation = $Rot2.rotation

func spawnThunder():
	checkAimShoot()
	$Sounds/Bigspell.play()
	var pr = THUNDERBOLT.instantiate()
	get_parent().add_child.call_deferred(pr)
	pr.position = global_position
	pr.apply_impulse(Vector2(200, 0).rotated($Rot2.rotation))
	pr.rotation = $Rot2.rotation

func spawnPoison():
	checkAimShoot()
	$Sounds/Bigspell.play()
	var pr = POISON.instantiate()
	get_parent().add_child.call_deferred(pr)
	pr.position = global_position

func spawnSnowflake():
	checkAimShoot()
	$Sounds/Bigspell.play()
	var pr = SNOW.instantiate()
	get_parent().add_child.call_deferred(pr)
	pr.position = global_position
	pr.apply_impulse(Vector2(100, 0).rotated($Rot2.rotation))
	pr.rotation = $Rot2.rotation

func spawnSparkle():
	var sp = SPARKLE.instantiate()
	get_parent().add_child.call_deferred(sp)
	sp.position = global_position

func spawnDeadBody():
	var dm = DEADMEEBLY.instantiate()
	get_parent().add_child.call_deferred(dm)
	dm.position = global_position

func spawnSplash():
	var ds = DEADSPLASH.instantiate()
	get_parent().add_child.call_deferred(ds)
	ds.position.x = global_position.x
	ds.position.y = global_position.y + $Meebling.position.y

# ----- Animation functions

func continueBouncing():
	m_anim.play("bounce")

# ----- Hurting and death functions

func updateHp():
	MAX_HP = MAX_HP + Globalsettings.currentrun_extrahealth
	$Healthbar.max_value = MAX_HP
	$Healthbar.visible = false
	hp = MAX_HP

func hurt():
	if alive == true:
		m_anim.play("RESET")
		m_anim.play("hurt")
		$Healthbar.value = hp # !!!!! Moved from physicsprocessdelta, check if it doesn't break the code
		$Healthbar.visible = true
		$Sounds/Hit.play()

func diefromwater():
	spawnSplash()
	velocity = Vector2(0,0)
	alive = false
	visible = false
	$Shadow.visible = false
	$Sounds/Break.play()
	$Sounds/Splash.play()
	$Timers/QueueTimer.start()

func drown():
	velocity = Vector2(0,0)
	m_anim.play("drown")
	alive = false
	$Timers/SplashTimer.start()
	$Shadow.visible = false
	$Sounds/Break.play()
	$Timers/QueueTimer.start()

func fallFromHigh():
	z_index = -1
	velocity = Vector2(0,0)
	m_anim.play("fallingfromabove")
	alive = false
	$Shadow.visible = false
	$Sounds/Break.play()

func kill():
	spawnDeadBody()
	alive = false
	$Sounds/Break.play()
	queue_free()

# Signals -----

func _on_hurtbox_crowd_area_entered(area):
	if area.is_in_group("EXPorb"):
		$Sounds/EXPpickup.play()
	if area.is_in_group("Cliff"):
		falling = true
		$Shadow.visible = false
		$Sounds/Fall.play()
		velocity.x = 0
		velocity.y = 0
	if area.is_in_group("Drownwater"):
		drown()

func _on_hurtbox_crowd_area_exited(area):
	if area.is_in_group("Cliff"):
		falling = false
		$Shadow.visible = true
		if fallingframes >= 20 && fallingframes < 40:
			hp -= 1
			hurt()
		if fallingframes >= 40 && fallingframes < 60:
			hp -= 2
			hurt()
		if fallingframes >= 60 && fallingframes < 80:
			hp -= 4
			hurt()
		if fallingframes >= 80 && fallingframes < 100:
			hp -= 8
			hurt()
		if fallingframes >= 100 && fallingframes < 120:
			hp -= 16
			hurt()
		if fallingframes >= 120 && fallingframes < 140:
			hp -= 32
			hurt()
		if fallingframes >= 140:
			kill()
		if hp <= 0 && alive == true:
			kill()
		fallingframes = 0

func _on_double_bullet_timer_timeout():
	spawnBullet()

func _on_cooldownstart_timer_timeout():
	if spellnumber == 1:
		crowdparent[0].spell1cooldown = 100
	if spellnumber == 2:
		crowdparent[0].spell2cooldown = 100
	if spellnumber == 3:
		crowdparent[0].spell3cooldown = 100
	if spellnumber == 4:
		crowdparent[0].spell4cooldown = 100

func _on_queue_timer_timeout():
	queue_free()

func _on_splash_timer_timeout():
	$Sounds/Splash.play()
