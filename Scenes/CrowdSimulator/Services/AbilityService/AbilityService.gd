extends Node

const noAbility := 0

##Cooldown per slots, and max cooldown for UI purposes
var slotCooldowns := [0.0, 0.0, 0.0, 0.0]
var slotCooldownMax := [1.0, 1.0, 1.0, 1.0]

##Dictionary that abilities spells and cooldowns
var abilityDictionary: Dictionary = {}

##Crowd simulator and needed services
@onready var crowdSimulator := get_parent()
@onready var attackService := crowdSimulator.get_node("AttackingService")

func _ready() -> void:
	##Builds the dictionary to hold all the abilities
	LoadAbilities()

func _physics_process(delta: float) -> void:
	##Ticks down cooldown
	TickCooldowns(delta)

func HandleAbilityInput() -> void:
	##Handles ability input
	if Input.is_action_just_pressed("spell1"):
		TryToCastAbility(1)
	if Input.is_action_just_pressed("spell2"):
		TryToCastAbility(2)
	if Input.is_action_just_pressed("spell3"):
		TryToCastAbility(3)
	if Input.is_action_just_pressed("spell4"):
		TryToCastAbility(4)

func TryToCastAbility(slot: int) -> void:
	##Convert slot to array id
	var id := slot - 1
	
	##Validate id and check cooldown
	if id < 0 or id >= slotCooldowns.size():
		return
	if slotCooldowns[id] > 0.0:
		return
	
	##Get equipped ability from global settings
	var abilityId := GetEquippedAbilityId(slot)
	if abilityId == noAbility:
		return
	
	##Look up ability in dictionary
	var ability: Dictionary = abilityDictionary.get(abilityId, {})
	if ability.is_empty():
		return
	
	##Get action to do on ability
	var action: Callable = ability.get("action", Callable())
	if not action.is_valid():
		return
	
	##Cast ability
	action.call()
	
	## Apply cooldown (seconds)
	var coolDown := float(ability.get("cooldown", 0.0))
	slotCooldowns[id] = coolDown
	slotCooldownMax[id] = max(coolDown, 0.01)

func GetSlotCooldown(slot: int) -> float:
	return slotCooldowns[slot - 1]

func GetSlotCooldownMax(slot: int) -> float:
	return slotCooldownMax[slot - 1]

func TickCooldowns(delta: float) -> void:
	for i in slotCooldowns.size():
		if slotCooldowns[i] > 0.0:
			slotCooldowns[i] = max(0.0, slotCooldowns[i] - delta)

func GetEquippedAbilityId(slot: int) -> int:
	##Get ability from global settings
	match slot:
		1: return Globalsettings.g_spell1
		2: return Globalsettings.g_spell2
		3: return Globalsettings.g_spell3
		4: return Globalsettings.g_spell4
	return noAbility

func LoadAbilities() -> void:
	##Dictionary including cooldowns and functions
	abilityDictionary = {
		1: { ## Fireball
			"cooldown": 1.2,
			"action": func(): attackService.fireProjectile(crowdSimulator.fireBall, attackService.fireballImpulse, true),
		},
		2: { ## Lightning
			"cooldown": 1.8,
			"action": func(): attackService.fireProjectile(crowdSimulator.lightningBolt, attackService.lightningImpulse, true),
		},
		3: { ## Poison
			"cooldown": 3.0,
			"action": func(): attackService.SpawnPoison(crowdSimulator.poison),
		},
		4: { ## Frost
			"cooldown": 2.2,
			"action": func(): attackService.fireProjectile(crowdSimulator.frost, attackService.frostImpulse, true),
		},
	}
