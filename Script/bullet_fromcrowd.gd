extends RigidBody2D

# Script for simple projectiles spawned by a Meebling. Includes basic bullet, fireball, thunder
# Weenter Approved (Great Cleanup, 10-9-24)

# Preload variables
var DMGVAL = preload("res://Scenes/damagenumber.tscn")

@export var damage = 5
@export var destroyonimpact = true

var bouncesleft = 0
var randomdir = 0

func _ready():
	bouncesleft = Globalsettings.currentrun_extrabounce
	randomize()
	changerandomdir()

# Functions -----

func hitImpact():
	queue_free()

func spawnDamageValue():
	var dv = DMGVAL.instantiate()
	get_parent().get_parent().add_child.call_deferred(dv)
	dv.position = global_position
	dv.dmg_value = damage + Globalsettings.currentrun_extraattack

# Signals -----

func _on_queue_timer_timeout():
	queue_free()

func changerandomdir():
	randomdir = randi()% 360 + 1

func _on_hitbox_bullet_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		area.get_parent().hp -= (damage + Globalsettings.currentrun_extraattack)
		area.get_parent().hurt()
		spawnDamageValue()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()
		if destroyonimpact == true:
			if bouncesleft >= 1:
				linear_velocity = Vector2(0,0)
				angular_velocity = 0
				apply_impulse(Vector2(200, 0).rotated(randomdir))
				rotation = randomdir
				$QueueTimer.start(3)
				changerandomdir()
				bouncesleft -= 1
			elif bouncesleft <= 0:
				hitImpact()
