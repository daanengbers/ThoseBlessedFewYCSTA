extends Node

##Onready vars
@onready var crowdSimulator = get_parent()
@onready var attackService = crowdSimulator.get_node("AttackingService")

const noAbility = 0

##UI vars
var uiSlotCooldowns = [0.0, 0.0, 0.0, 0.0]
var uiSlotCooldownMax = [1.0, 1.0, 1.0, 1.0]

##Dictionary of abilities
var abilitiesById : Dictionary = {}

##===============================##

###Standard Functions###

func _ready() -> void:
	RegisterAbilities()

func _physics_process(delta: float) -> void:
	TickCooldowns(delta)

###Standard Functions###

##===============================##

###Input Functions###

func HandleAbilityInput() -> void:
	if Input.is_action_just_pressed("spell1"):
		TryToCastAbility(1)
	if Input.is_action_just_pressed("spell2"):
		TryToCastAbility(2)
	if Input.is_action_just_pressed("spell3"):
		TryToCastAbility(3)
	if Input.is_action_just_pressed("spell4"):
		TryToCastAbility(4)

###Input Functions###

##===============================##

###Ability loading Functions###

func RegisterAbilities() -> void:
	##Clear any previous abilities
	abilitiesById.clear()
	
	##Get children of the abilityService
	for child in get_children():
		
		##Filter out anything that isn't an ability
		if child is AbilityBase:
			
			##Make a var of the child
			var ability = child as AbilityBase
			
			##Check if the ability id is properly set
			if ability.abilityId == 0:
				push_warning("Ability '%s' has abilityId = 0 (invalid), skipping." % ability.name)
				continue
				
			##Add the ability id to the array
			abilitiesById[ability.abilityId] = ability

###Ability loading Functions###

##===============================##

###Ability casting Functions###

func TryToCastAbility(slot: int) -> void:
	##Create a usable var with the slot
	var id = slot - 1
	
	##If the id is invalid or the cooldown is not yet done, return
	if id < 0 or id >= uiSlotCooldowns.size():
		return
	if uiSlotCooldowns[id] > 0.0:
		return
	
	##Get the abilityId that corrosponds the the slot
	var abilityId = GetEquippedAbilityId(slot)
	if abilityId == noAbility:
		return
	
	##Get the ability corrosponding to the id
	var ability : AbilityBase = abilitiesById.get(abilityId, null)
	
	##Check if anything is wrong with the ability
	if ability == null:
		return
	if ability.currentLevel <= 0:
		return
	
	##Use the child to cast the ability
	ability.Cast(crowdSimulator, attackService)
	
	##Get the cooldown of the stat
	var coolDown = ability.GetCooldown()
	
	##Make the cooldown of the slot corrospond with the returned cooldown
	uiSlotCooldowns[id] = coolDown
	uiSlotCooldownMax[id] = max(coolDown, 0.01)

func GetEquippedAbilityId(slot: int) -> int:
	match slot:
		1: return Globalsettings.g_spell1
		2: return Globalsettings.g_spell2
		3: return Globalsettings.g_spell3
		4: return Globalsettings.g_spell4
	return noAbility

###Ability loading Functions###

##===============================##

###Cooldown Functions###

func GetSlotCooldown(slot: int) -> float:
	return uiSlotCooldowns[slot - 1]

func GetSlotCooldownMax(slot: int) -> float:
	return uiSlotCooldownMax[slot - 1]

func TickCooldowns(delta: float) -> void:
	for i in uiSlotCooldowns.size():
		if uiSlotCooldowns[i] > 0.0:
			uiSlotCooldowns[i] = max(0.0, uiSlotCooldowns[i] - delta)

###Cooldown Functions###

##===============================##

###Ability locking/leveling Functions###

func SetAbilityLevel(abilityId: int, newLevel: int) -> void:
	var ability: AbilityBase = abilitiesById.get(abilityId, null)
	if ability == null:
		return
	ability.currentLevel = clampi(newLevel, 0, ability.maxLevel)

###Ability locking Functions###

##===============================##
