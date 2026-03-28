extends Node

##References
@onready var crowdSimulator : CharacterBody2D = get_parent()
@onready var xpBar = $"../UI/LVLbar"
@onready var xpText = $"../UI/LVLtext" 

@onready var mapAbilityPrompt = $"../UI/AbilityMapPrompt"
@onready var Key1UI = $"../UI/AbilityMapPrompt/G"
@onready var Key2UI = $"../UI/AbilityMapPrompt/H"
@onready var Key3UI = $"../UI/AbilityMapPrompt/V"
@onready var Key4UI = $"../UI/AbilityMapPrompt/B"

@onready var statUISprites : Array[Sprite2D] = [
	$"../UI/StatHolder/Box01/StatIcons",
	$"../UI/StatHolder/Box02/StatIcons",
	$"../UI/StatHolder/Box03/StatIcons",
	$"../UI/StatHolder/Box04/StatIcons",
	]

@onready var statUILabels : Array[Label] = [
	$"../UI/StatHolder/Box01/Label",
	$"../UI/StatHolder/Box02/Label",
	$"../UI/StatHolder/Box03/Label",
	$"../UI/StatHolder/Box04/Label",
]

@onready var abilityService = crowdSimulator.get_node("AbilityService")

##Preload vars
var levelUpCardScene = preload("res://Scenes/CrowdSimulator/Services/LevelingService/LevelingCards/LevelUpCardBase.tscn")

##XP vars
var xp : int = 0
var xpNeededToLevel : int = 100

##Level vars
var level : int = 0
var pendingLevelUps : int = 0

##Leveling stats
var statSlotsAvailable : int = 4
var abilitySlotsAvailable : int = 4

var currentStatSlotLocked : int = 1

var isChoosingUpgrade : bool = false
var isPickingAbilitySlot : bool = false

##Ability var
var pendingAbility : AbilityBase = null
var slotsTaken : Array[int] = []

##UI vars
var chosenCards = []
var shownCards = []

var cardSpacing : float = 140.0
var screenCenter : float = 240.0
var cardY : float = 135

var selectedCardIndex : int = 0

var arrow = preload("res://Scenes/CrowdSimulator/Services/LevelingService/LevelingArrow/LevelUpArrow.tscn")
var arrowIn


##===============================##

###Standard functions###

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	xpBar.max_value = xpNeededToLevel
	createAndHideArrow()

###Standard functions###

##===============================##

###Input functions###

func _unhandled_input(event):
	if isPickingAbilitySlot:
		HandleSlotPickInput(event)
	elif isChoosingUpgrade:
		HandleCardInput(event)
	

func HandleCardInput(event):
	if event.is_action_pressed("left"):
		selectedCardIndex = max(0, selectedCardIndex - 1)
		UpdateArrowUI()
	elif event.is_action_pressed("right"):
		selectedCardIndex = min(shownCards.size() - 1, selectedCardIndex + 1)
		UpdateArrowUI()
	elif event.is_action_pressed("ui_accept"):
		ConfirmSelection()

func ConfirmSelection():
	if chosenCards.size() == 0:
		return
	var chosen : UpgradeBase = chosenCards[selectedCardIndex]
	ApplyUpgrade(chosen)

func HandleSlotPickInput(event) -> void:
	var slotPressed := 0
	if event.is_action_pressed("spell1"):
		slotPressed = 1
	elif event.is_action_pressed("spell2"):
		slotPressed = 2
	elif event.is_action_pressed("spell3"):
		slotPressed = 3
	elif event.is_action_pressed("spell4"):
		slotPressed = 4
	
	if slotPressed == 0:
		return
	if pendingAbility == null:
		return
	
	##Check if slot is alreadt chosen
	if GetEquippedAbilityId(slotPressed) != 0:
		return
	
	MapAbilityToSlot(pendingAbility, slotPressed)

###Input functions###

##===============================##

###XP Functions###

func GetXp(amount : int):
	##Up xp by amount, then update the UI accordingly
	xp += amount
	xpBar.value = xp
	
	##While xp is higher than the xp needed to level up
	while xp >= xpNeededToLevel:
		##Remove the amount of xp that is needed for this level
		xp -= xpNeededToLevel
		
		##Update the UI
		xpBar.value = xp
		
		##Add one pending level up
		pendingLevelUps += 1
		
		##Increase the xp needed to level up
		IncreaseXpThreshold()
	
	##If there is one more level ups pending and the player is not already choosing an upgrade, trigger level up
	if pendingLevelUps > 0 and not isChoosingUpgrade:
		TriggerNextLevelUp()

func IncreaseXpThreshold():
	##Up the xp needed and update UI
	xpNeededToLevel = roundi(level/0.07)^2
	xpBar.max_value = xpNeededToLevel

###XP Functions###

##===============================##

###Leveling Functions###

func TriggerNextLevelUp():
	##Check if there are any level ups left
	if pendingLevelUps <= 0:
		return
	
	##Up the level by one, then set the UI accordingly
	level += 1
	xpText.set_text("Level " + str(level))
	
	##Remove one pending level up
	pendingLevelUps -= 1
	
	##Get an array of filtered level up options
	var cardOptions = GetAvailableCards()
	if cardOptions.size() == 0:
		return
	
	StartLevelUpUI(cardOptions)
	get_tree().paused = true

func ApplyUpgrade(upgrade: UpgradeBase) -> void:
	if upgrade.upgradeType == UpgradeBase.UpgradeType.Stat:
		var stat = upgrade as StatUpgrade
		
		##Check if stat is already chosen, if not, set slot and enable UI
		if stat.currentLevel == 0 and stat.slot == -1:
			stat.slot = currentStatSlotLocked
			currentStatSlotLocked += 1
			
			##Update UI
			UpdateUIStatSlots(stat)
		
		##Apply upgrade
		stat.ApplyStatLevel()
		
		##if slot is taken, update UI
		if stat.slot != -1:
			UpdateUIStatSlots(stat)
		
		##Continue with the game
		ClearAndResume()
		return
	
	if upgrade.upgradeType == UpgradeBase.UpgradeType.Ability:
		var ability := upgrade as AbilityBase
		ApplyAbility(ability)
		return

func ApplyAbility(ability: AbilityBase) -> void:
	##Check if it is a new ability
	if ability.currentLevel == 0:
		pendingAbility = ability
		isChoosingUpgrade = false
		isPickingAbilitySlot = true
		ClearExistingCards()
		ShowSlotPickPrompt()
		return
	
	##If already owned, level up the ability
	ability.currentLevel += 1
	abilityService.SetAbilityLevel(ability.abilityId, ability.currentLevel)
	ClearAndResume()

func MapAbilityToSlot(ability: AbilityBase, slot: int) -> void:
	##Set ability to correct slot
	match slot:
		1: 
			Globalsettings.g_spell1 = ability.abilityId
			$"../UI/AbilityBoxes/Box01/UpgradeIcons".frame = (ability.spriteFrame + $"../UI/AbilityBoxes/Box01/UpgradeIcons".hframes)
		2: 
			Globalsettings.g_spell2 = ability.abilityId
			$"../UI/AbilityBoxes/Box02/UpgradeIcons".frame = (ability.spriteFrame + $"../UI/AbilityBoxes/Box01/UpgradeIcons".hframes)
		3: 
			Globalsettings.g_spell3 = ability.abilityId
			$"../UI/AbilityBoxes/Box03/UpgradeIcons".frame = (ability.spriteFrame + $"../UI/AbilityBoxes/Box01/UpgradeIcons".hframes)
		4: 
			Globalsettings.g_spell4 = ability.abilityId
			$"../UI/AbilityBoxes/Box04/UpgradeIcons".frame = (ability.spriteFrame + $"../UI/AbilityBoxes/Box01/UpgradeIcons".hframes)
	
	##Add the taken slot to the list for UI and tracking purposes
	slotsTaken.append(slot)
	
	##Set ability level to 1
	ability.currentLevel = 1
	abilityService.SetAbilityLevel(ability.abilityId, 1)
	
	##Cleanup slot picking
	HideSlotPickPrompt()
	isPickingAbilitySlot = false
	pendingAbility = null
	
	arrowIn.visible = false
	
	##Continue with pending upgrades or stop leveling
	if pendingLevelUps > 0:
		TriggerNextLevelUp()
	else:
		get_tree().paused = false

###Leveling Functions###

##===============================##

###Card Functions###

func GetAvailableCards():
	##Create two pools split by type
	var stats : Array = []
	var abilities : Array  = []
	
	##Get all upgrades
	for upgrade in get_tree().get_nodes_in_group("Upgrades"):
		##Filter out everything that is not an upgrade
		if not (upgrade is UpgradeBase):
			continue
		
		##Make an instance of the upgrade
		var upgradeIn : UpgradeBase = upgrade
		
		##Filter out max upgraded
		if not upgradeIn.CanUpgrade():
			continue
		
		##Add the upgrade to the correct pool
		if upgradeIn.upgradeType == UpgradeBase.UpgradeType.Stat:
			stats.append(upgradeIn)
		elif upgradeIn.upgradeType == UpgradeBase.UpgradeType.Ability:
			abilities.append(upgradeIn)
	
	##Count currently owned stats/abilities
	var ownedStats = stats.filter(func(s): return s.currentLevel > 0)
	var ownedAbilities = abilities.filter(func(s): return s.currentLevel > 0)
	
	##Create the final pool to be returned
	var cardPool = []
	
	##Check if there are still stat slots left over
	var statSlotsOpen = ownedStats.size() < statSlotsAvailable
	
	##Add stats to the pool
	for stat in stats:
		##If the stat is not already locked and there are no slots left, skip
		if stat.currentLevel == 0 and not statSlotsOpen:
			continue
		##Add filtered stat to pool
		cardPool.append(stat)
	
	##Check if there are still ability slots left over
	var abilitySlotsOpen = ownedAbilities.size() < abilitySlotsAvailable
	
	##Add abilities to the pool
	for ability in abilities:
		##If the ability is not already locked and there are no slots left, skip
		if ability.currentLevel == 0 and not abilitySlotsOpen:
			continue
		##Add filtered ability to pool
		cardPool.append(ability)
	
	##Return filtered pool
	return cardPool

###Card Functions###

##===============================##

###UI Functions###

func StartLevelUpUI(cardOptions):
	##Make sure that the previous level up is cleared
	ClearExistingCards()
	
	##Pick at most 3 random cards(dependent on amount of slots)
	chosenCards = PickNRandom(cardOptions, 3)
	
	##Get the amount of cards chosen
	var cardCount = chosenCards.size()
	
	##Calculate the width and starting positions for the cards
	var totalWidth = (cardCount - 1) * cardSpacing
	var startX = screenCenter - totalWidth / 2.0
	
	##For the amount of cards chosen
	for i in range(cardCount):
		##Instantiate a new card
		var cardIn = levelUpCardScene.instantiate()
		
		##Update its UI
		SetCardContent(cardIn, chosenCards[i])
		
		##Set its position based on previous calculations
		cardIn.position = Vector2(startX + i * cardSpacing, cardY)
		
		##Add the new card to the scene tree
		crowdSimulator.get_node("UI").add_child(cardIn)
		
		##Add the new card to the shownCards array
		shownCards.append(cardIn)
	
	##Set the selectedIndex to 0 (default val)
	selectedCardIndex = 0
	
	##Set isChoosingUpgrade to true to prevent other actions
	isChoosingUpgrade = true
	
	##Create and set the arrow
	UpdateArrowUI()

func SetCardContent(emptyCardInstance, chosenCard):
	##Set the UI of the instanciated card to the randomly chosen upgrades
	emptyCardInstance.get_node("CardName").text = chosenCard.cardName
	emptyCardInstance.get_node("CardLevel").text = "LVL " + str(chosenCard.currentLevel)
	emptyCardInstance.get_node("CardDescription").text = chosenCard.description[chosenCard.currentLevel]
	
	if chosenCard.upgradeType == UpgradeBase.UpgradeType.Stat:
		emptyCardInstance.get_node("CardSpriteBase").frame = 0
		emptyCardInstance.get_node("CardSpriteUpgrade").frame = chosenCard.spriteFrame
	if chosenCard.upgradeType == UpgradeBase.UpgradeType.Ability:
		emptyCardInstance.get_node("CardSpriteBase").frame = 1
		emptyCardInstance.get_node("CardSpriteUpgrade").frame = (chosenCard.spriteFrame + emptyCardInstance.get_node("CardSpriteUpgrade").hframes)

func UpdateArrowUI():
	##Checks if any cards are shown
	if shownCards.size() == 0:
		return
	
	##calculates the offset and position
	var arrowOffset = Vector2(0, 80)
	var targetPos = shownCards[selectedCardIndex].position + arrowOffset
	
	##Makes the arrow visible and sets it to the correct pos
	arrowIn.visible = true
	arrowIn.position = targetPos

func ShowSlotPickPrompt() -> void:
	##Show the ability prompt
	mapAbilityPrompt.visible = true
	
	##Hide the UI buttons that are taken already
	for slot in slotsTaken:
		if slot == 1:
			Key1UI.visible = false
		if slot == 2:
			Key2UI.visible = false
		if slot == 3:
			Key3UI.visible = false
		if slot == 4:
			Key4UI.visible = false

func HideSlotPickPrompt() -> void:
	##Show the ability prompt
	mapAbilityPrompt.visible = false

func ClearExistingCards():
	for card in shownCards:
		if is_instance_valid(card):
			card.queue_free()
	shownCards.clear()

func UpdateUIStatSlots(stat : StatUpgrade):
	var id = stat.slot - 1
	
	if id < statUISprites.size():
		statUISprites[id].visible = true
		statUISprites[id].frame = stat.spriteFrame
	
	if id < statUILabels.size():
		statUILabels[id].visible = true
		statUILabels[id].text = "LVL " + str(stat.currentLevel)


###UI Functions###

##===============================##

###Helper Functions###

func GetEquippedAbilityId(slot: int) -> int:
	match slot:
		1: return Globalsettings.g_spell1
		2: return Globalsettings.g_spell2
		3: return Globalsettings.g_spell3
		4: return Globalsettings.g_spell4
	return 0

func ClearAndResume() -> void:
	##Clear existing cards
	ClearExistingCards()
	
	##Hide arrow
	arrowIn.visible = false
	
	##Stop choosing upgrades
	isChoosingUpgrade = false
	
	##Check for pending level ups, else continue game
	if pendingLevelUps > 0:
		TriggerNextLevelUp()
	else:
		get_tree().paused = false

##Picks n random unique upgrades from the pool
func PickNRandom(cardsAvailable, n):
	var cardPool = cardsAvailable.duplicate()
	cardPool.shuffle()
	return cardPool.slice(0, min(n, cardPool.size()))

func createAndHideArrow():
	arrowIn = arrow.instantiate()
	arrowIn.visible = false
	crowdSimulator.get_node("UI").add_child(arrowIn)

###Helper Functions###

##===============================##
