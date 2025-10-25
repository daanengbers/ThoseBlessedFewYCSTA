extends CharacterBody2D

const arrowSpeed = 60
const aimSpeed = 4
const acceleration = 0.1

var meebling = preload("res://Scenes/MeeblingNew.tscn")
var bullet = preload("res://Scenes/bullet_fromcrowd.tscn")
var meeblings
var enemies



func _ready():
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	birthMeebling(global_position)
	
	var arrownr = Globalsettings.global_arrow
	$Mainarrow/Anim.play("arrow" + str(arrownr))
	pass

func birthMeebling(spawnPos):
	##Instantiate meebling
	var newMeebling = meebling.instantiate()
	
	##Add the instantiated meebling as a child to the arrow
	add_child.call_deferred(newMeebling)
	
	##Run the randomiser and setup for the meebling
	newMeebling.randomizeAndSetup()
	
	##Spawn the meebling at the correct location
	if(spawnPos == global_position):
		newMeebling.position.x = spawnPos.x + newMeebling.randomxplus
		newMeebling.position.y = spawnPos.y + newMeebling.randomyplus
	else:
		newMeebling.position = spawnPos
	
	##Play birth animation
	newMeebling.birthEffectsBegin()
	
	##Wait till animation is done
	await get_tree().create_timer(3.0).timeout
	
	##End birth animation
	newMeebling.birthEffectsEnd()

func meeblingDied():
	##When a meebling dies, check the amount of meeblings left and act accordingly
	pass

func getClosestEnemy():
	##Make an array with all enemies
	enemies = get_tree().get_nodes_in_group("enemy_m")
	
	##Set the closest distance, then set it to INF so it is always bigger than the first vallue
	var closestDistance : float = INF
	
	##Loop through all enemies in the array when the array has more than one enemy in it
	if enemies.size() >= 1:
		for enemy in enemies:
			##Calculate the distance
			var distance : float = global_position.distance_squared_to(enemy.global_position)
			##Compare the distance to the the closest distance so far
			if distance < closestDistance:
				##If the distance is closer, set the closest enemy to this enemy and set the closest distance to this distance
				Globalsettings.globalClosestEnemy = enemy
				closestDistance = distance

func basicAttack():
	##Get the closest enemy
	getClosestEnemy()
	
	##Make an array with all enemies
	meeblings = get_tree().get_nodes_in_group("meeblings")
	
	##Play sound effect
	##$Sounds/Shoot.play() Play SE
	
	##Loop through all meeblings
	for meeb in meeblings:
		##Instantiate a new bullet
		var bullet = bullet.instantiate()
		
		##Add the bullet as a child to the meebling
		meeb.add_child.call_deferred(bullet)
		
		##Set the bullet position to the position of the meebling
		bullet.global_position = meeb.global_position
		
		##Get the rotation towards the closest enemy
		var rotation = meeb.rotateTowardsEnemy()
		
		##Move the bullet from the meebling to the closest enemy
		bullet.apply_impulse(Vector2(200, 0).rotated(rotation))
		
		##Set the rotation of the bullet to match the direction of the bullet
		bullet.rotation = rotation
	##if currentextrabullets > 0:
		##$Timers/DoubleBulletTimer.start()
		##currentextrabullets -= 1
	
	##Every so many secconds, instantiate a bullet at every meebling in array and shoot them toward the closest enemy
	pass

func sacMeeblings(int):
	##Sac the specified amount of meeblings
	pass

func levelUp():
	##Handel leveling up
	pass

func get_Input():
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	return Vector2(horizontal, vertical)

func movement():
	var direction = get_Input()
	velocity = velocity.lerp(direction.normalized() * arrowSpeed , acceleration ) ##+ Globalsettings.currentrun_extraspeed
	move_and_slide()

func _physics_process(_delta):
	##Movement
	movement()
	
	##Attacking
	if Engine.get_process_frames() % 40 == 0:
		basicAttack()
	##Manage the meebling stats
	##Manage level
	##Manage movement
	##Manage Shooting
	##Manage group
	##Manage enemy targeting
