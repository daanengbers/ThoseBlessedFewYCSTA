extends RigidBody2D

var DamageNumber = GameResources.damageNumberScene

@export var BaseDamage = 5
@export var DestroyOnImpact = true

var BouncesLeft = 0
var RandomDirection = 0

func _ready():
	BouncesLeft = Globalsettings.currentrun_extrabounce
	randomize()
	set_as_top_level(true)
	changerandomdir()

func hitImpact():
	queue_free()

func spawnDamageValue():
	var DamageValue = DamageNumber.instantiate()
	get_parent().get_parent().add_child.call_deferred(DamageValue)
	DamageValue.position = global_position
	DamageValue.dmg_value = BaseDamage + Globalsettings.currentrun_extraattack

# Signals -----

func _on_queue_timer_timeout():
	queue_free()

func changerandomdir():
	RandomDirection = randi()% 360 + 1

func _on_hitbox_bullet_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		area.get_parent().hp -= (BaseDamage + Globalsettings.currentrun_extraattack)
		area.get_parent().hurt()
		spawnDamageValue()
		if area.get_parent().hp <= 0:
			area.get_parent().kill()
		if DestroyOnImpact == true:
			if BouncesLeft >= 1:
				linear_velocity = Vector2(0,0)
				angular_velocity = 0
				apply_impulse(Vector2(200, 0).rotated(RandomDirection))
				rotation = RandomDirection
				$QueueTimer.start(3)
				changerandomdir()
				BouncesLeft -= 1
			elif BouncesLeft <= 0:
				hitImpact()
