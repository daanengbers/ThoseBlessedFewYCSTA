extends Node

##References
@onready var crowdSimulator : CharacterBody2D = get_parent()
@onready var xpBar = $"../UI/LVLbar"
@onready var xpText = $"../UI/LVLtext"

##Preload vars
var levelUpCardScene = preload("res://Scenes/CrowdSimulator/Services/LevelingService/LevelUpCardBase.tscn")

##Level vars
var xp : int = 0
var xpNeededToLevelUp : int = 5
var level : int = 1
var pendingLevelUps : int = 0

##Upgrade tracking vars
var statLibrary : Dictionary = {}
var ownedUpgrades : Dictionary = {} ##Key = card id, Value = current level
var ownedAbilities : Dictionary = {} ##Key = card id, Value = current level
var abilitySlotMap : Dictionary = {1: 0, 2: 0, 3: 0, 4: 0} ##Slot -> card id, 0 = empty
var maxStatSlots : int = 4
var maxAbilitySlots : int = 4

##UI vars
var shownCards : Array = []
var cardOptions : Array = []
var selectedCardIndex : int = 0
var isChoosingUpgrade : bool = false

##Ability slot picking vars
var pendingAbilityCardId : int = 0
var isPickingAbilitySlot : bool = false

##===============================##

###Standard functions###

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	xpBar.max_value = xpNeededToLevelUp
	LoadStats()

func _process(delta):
	pass

func _unhandled_input(event):
	if isPickingAbilitySlot:
		HandleSlotPickInput(event)
	elif isChoosingUpgrade:
		HandleCardInput(event)

###Standard functions###

##===========================================##

###XP and leveling###

##Adds xp to the bar from various sources
func GetXp(amount : int):
	xp += amount
	Globalsettings.global_xp = xp
	xpBar.value = xp
	
	while xp >= xpNeededToLevelUp:
		xp -= xpNeededToLevelUp
		Globalsettings.global_xp = xp
		xpBar.value = xp
		pendingLevelUps += 1
		IncreaseXpThreshold()
	
	##Only trigger the first level up, the rest are queued
	if pendingLevelUps > 0 and not isChoosingUpgrade:
		TriggerNextLevelUp()

##Triggers the next queued level up
func TriggerNextLevelUp():
	if pendingLevelUps <= 0:
		return
	
	level += 1
	pendingLevelUps -= 1
	
	xpText.set_text("Level " + str(level))
	
	var options = GetAvailableUpgrades()
	if options.size() == 0:
		return
	
	ShowLevelUpChoices(options)
	get_tree().paused = true

##Increases the xp needed to level up based on the current level
func IncreaseXpThreshold():
	if level <= 5:
		xpNeededToLevelUp += 5
	elif level >= 6 and level <= 10:
		xpNeededToLevelUp += 10
	elif level >= 15 and level <= 20:
		xpNeededToLevelUp += 15
	elif level >= 30 and level <= 40:
		xpNeededToLevelUp += 30
	elif level >= 71 and level <= 90:
		xpNeededToLevelUp += 6
	elif level >= 91 and level <= 100:
		xpNeededToLevelUp += 7
	elif level >= 101:
		xpNeededToLevelUp += 10 + level * 2
	
	xpBar.max_value = xpNeededToLevelUp

###XP and leveling###

##===========================================##

###Upgrade pool and selection###

##Returns a pool of all available stats and abilities that are not maxed
func GetAvailableUpgrades():
	var pool = []
	for id in statLibrary.keys():
		var entry = statLibrary[id]
		var entryType = entry.get("type", "stat")
		
		if entryType == "stat":
			var currentLevel = ownedUpgrades.get(id, 0)
			var maxLevel = entry["maxLevel"]
			if currentLevel < maxLevel:
				pool.append({
					"id": id,
					"type": "stat",
					"cardName": entry["cardName"],
					"description": entry["description"],
					"currentLevel": currentLevel,
					"nextLevel": currentLevel + 1,
					"maxLevel": maxLevel,
					"spriteFrame": entry.get("spriteFrame", 0),
				})
		
		elif entryType == "ability":
			var currentLevel = ownedAbilities.get(id, 0)
			var maxLevel = entry["maxLevel"]
			##Only include if not maxed
			if currentLevel < maxLevel:
				##Only include new abilities if there is a free slot
				var hasFreeSlot = abilitySlotMap.values().has(0)
				if currentLevel == 0 and not hasFreeSlot:
					continue
				pool.append({
					"id": id,
					"type": "ability",
					"abilityId": entry["abilityId"],
					"cardName": entry["cardName"],
					"description": entry["description"],
					"currentLevel": currentLevel,
					"nextLevel": currentLevel + 1,
					"maxLevel": maxLevel,
					"spriteFrame": entry.get("spriteFrame", 0),
				})
		
	return pool

##Picks n random unique upgrades from the pool
func PickNRandom(arr, n):
	var pool = arr.duplicate()
	pool.shuffle()
	return pool.slice(0, min(n, pool.size()))

##Applies the chosen upgrade depending on its type
func ApplyUpgrade(upgrade):
	if upgrade["type"] == "stat":
		ApplyStat(upgrade)
		ClearAndResume()
	elif upgrade["type"] == "ability":
		ApplyAbility(upgrade)

##Applies a stat upgrade directly
func ApplyStat(upgrade):
	var id = upgrade["id"]
	var nextLevel = upgrade["nextLevel"]
	ownedUpgrades[id] = nextLevel
	
	var levelValues = statLibrary[id]["levels"]
	var valueIndex = nextLevel - 1
	if valueIndex >= 0 and valueIndex < levelValues.size():
		ApplyStatEffect(id, levelValues[valueIndex])

##Handles ability upgrade - either maps to a slot or levels up
func ApplyAbility(upgrade):
	var id = upgrade["id"]
	
	if not ownedAbilities.has(id):
		##New ability - wait for player to pick a slot
		pendingAbilityCardId = id
		isChoosingUpgrade = false
		isPickingAbilitySlot = true
		ClearExistingCards()
		ShowSlotPickPrompt()
		##Do not unpause yet - wait for slot selection
	else:
		##Already owned - level it up in AbilityService
		var nextLevel = upgrade["nextLevel"]
		ownedAbilities[id] = nextLevel
		var abilityId = statLibrary[id]["abilityId"]
		crowdSimulator.get_node("AbilityService").LevelUpAbility(abilityId, nextLevel)
		ClearAndResume()

##Applies the actual stat effect to globalsettings
func ApplyStatEffect(id, value):
	match id:
		1: ##Attack
			Globalsettings.currentrun_extraattack += value
		2: ##Speed
			Globalsettings.currentrun_extraspeed += value
		3: ##Cooldown
			Globalsettings.currentrun_minuscooldown += value
		4: ##Amount
			Globalsettings.currentrun_extrabullets += value
		5: ##Health
			Globalsettings.currentrun_extrahealth += value

##Cleans up cards and resumes or triggers next level up
func ClearAndResume():
	ClearExistingCards()
	var arrow = GetOrCreateArrow()
	arrow.visible = false
	isChoosingUpgrade = false
	
	if pendingLevelUps > 0:
		TriggerNextLevelUp()
	else:
		get_tree().paused = false

###Upgrade pool and selection###

##===========================================##



##===========================================##

###Card display###

##Shows the level up choices by instantiating card scenes
func ShowLevelUpChoices(options):
	ClearExistingCards()
	cardOptions = PickNRandom(options, 3)
	shownCards = []
	
	var cardCount = cardOptions.size()
	var cardSpacing = 140.0
	var screenCenter = 240.0 ##Half of 480 (viewport width)
	var totalWidth = (cardCount - 1) * cardSpacing
	var startX = screenCenter - totalWidth / 2.0
	var cardY = 135.0
	
	for i in range(cardCount):
		var card = levelUpCardScene.instantiate()
		SetCardContent(card, cardOptions[i])
		card.position = Vector2(startX + i * cardSpacing, cardY)
		crowdSimulator.get_node("UI").add_child(card)
		shownCards.append(card)
	
	selectedCardIndex = 0
	isChoosingUpgrade = true
	UpdateArrowPosition()

##Sets the content of a card based on the upgrade dictionary
func SetCardContent(card, upgrade):
	card.get_node("CardName").text = upgrade["cardName"]
	card.get_node("CardLevel").text = "Level " + str(upgrade["nextLevel"])
	card.get_node("CardDescription").text = upgrade["description"]
	
	if statLibrary.has(upgrade["id"]):
		var spriteFrame = statLibrary[upgrade["id"]].get("spriteFrame", 0)
		card.get_node("CardSpriteUpgrade").frame = spriteFrame
	
	if upgrade["currentLevel"] == 0:
		card.get_node("CardSpriteBase").frame = 0 ##New
	else:
		card.get_node("CardSpriteBase").frame = 1 ##Upgrade

###Card display###

##===========================================##

###Arrow selector###

##Updates the arrow position to point at the currently selected card
func UpdateArrowPosition():
	if shownCards.size() == 0:
		return
	
	var arrowOffset = Vector2(0, 80)
	var targetPos = shownCards[selectedCardIndex].position + arrowOffset
	
	var arrow = GetOrCreateArrow()
	arrow.visible = true
	arrow.position = targetPos

##Gets the arrow node, or creates one if it doesnt exist yet
func GetOrCreateArrow():
	var uiLayer = crowdSimulator.get_node("UI")
	if uiLayer.has_node("LevelUpArrow"):
		return uiLayer.get_node("LevelUpArrow")
	
	var arrow = Sprite2D.new()
	arrow.name = "LevelUpArrow"
	arrow.texture = preload("res://Assets/UI/Selectcardarrow.png")
	arrow.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	arrow.hframes = 2
	arrow.vframes = 2
	arrow.visible = false
	uiLayer.add_child(arrow)
	return arrow

###Arrow selector###

##===========================================##

###Input handling###

##Handles left/right navigation and confirm input during level up
func HandleCardInput(event):
	if event.is_action_pressed("left"):
		selectedCardIndex = max(0, selectedCardIndex - 1)
		UpdateArrowPosition()
	elif event.is_action_pressed("right"):
		selectedCardIndex = min(shownCards.size() - 1, selectedCardIndex + 1)
		UpdateArrowPosition()
	elif event.is_action_pressed("ui_accept"):
		ConfirmSelection()

##Confirms the selected card and applies the upgrade
func ConfirmSelection():
	if cardOptions.size() == 0:
		return
	ApplyUpgrade(cardOptions[selectedCardIndex])

##Handles slot pick input when a new ability is being mapped
func HandleSlotPickInput(event):
	var slotPressed = 0
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
	
	##Check if the slot is already taken
	if abilitySlotMap[slotPressed] != 0:
		##Slot is taken, ignore input
		return
	
	##Map the ability to the chosen slot
	MapAbilityToSlot(pendingAbilityCardId, slotPressed)

##Maps a new ability card id to a slot and applies it
func MapAbilityToSlot(cardId, slot):
	var abilityId = statLibrary[cardId]["abilityId"]
	abilitySlotMap[slot] = cardId
	ownedAbilities[cardId] = 1
	
	##Update globalsettings so AbilityService picks it up
	match slot:
		1: Globalsettings.g_spell1 = abilityId
		2: Globalsettings.g_spell2 = abilityId
		3: Globalsettings.g_spell3 = abilityId
		4: Globalsettings.g_spell4 = abilityId
	
	##Clean up slot picking state
	HideSlotPickPrompt()
	isPickingAbilitySlot = false
	pendingAbilityCardId = 0
	
	var arrow = GetOrCreateArrow()
	if arrow:
		arrow.visible = false
	
	##Resume or trigger next level up
	if pendingLevelUps > 0:
		TriggerNextLevelUp()
	else:
		get_tree().paused = false

###Input handling###

##===========================================##

###Slot pick prompt###

##Shows a prompt telling the player to press a spell button to map the ability
func ShowSlotPickPrompt():
	var uiLayer = crowdSimulator.get_node("UI")
	if uiLayer.has_node("SlotPickPrompt"):
		uiLayer.get_node("SlotPickPrompt").visible = true
		return
	
	var prompt = Label.new()
	prompt.name = "SlotPickPrompt"
	prompt.text = "Press a spell button to map this ability"
	prompt.add_theme_font_override("font", preload("res://Fonts/EXEPixelPerfect.ttf"))
	prompt.add_theme_font_size_override("font_size", 16)
	prompt.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	prompt.add_theme_constant_override("outline_size", 4)
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	prompt.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	uiLayer.add_child(prompt)

##Hides the slot pick prompt
func HideSlotPickPrompt():
	var uiLayer = crowdSimulator.get_node("UI")
	if uiLayer.has_node("SlotPickPrompt"):
		uiLayer.get_node("SlotPickPrompt").visible = false

###Slot pick prompt###

##===========================================##

###Cleanup###

##Removes all instantiated card nodes
func ClearExistingCards():
	for card in shownCards:
		if is_instance_valid(card):
			card.queue_free()
	shownCards.clear()
	cardOptions.clear()

###Cleanup###

##===============================##

###Stat and ability library###

##Library to keep stat and ability values, levels, and max levels
func LoadStats():
	statLibrary = {
		1: { ##Attack
			"type": "stat",
			"cardName": "Attack",
			"description": "+5 Attack",
			"levels": [5, 5, 10, 10, 15],
			"maxLevel": 5,
			"spriteFrame": 0,
		},
		2: { ##Speed
			"type": "stat",
			"cardName": "Speed",
			"description": "+2 Speed",
			"levels": [2, 2, 4, 4, 8],
			"maxLevel": 5,
			"spriteFrame": 1,
		},
		3: { ##Cooldown
			"type": "stat",
			"cardName": "Cooldown",
			"description": "-5 Cooldown",
			"levels": [5, 5, 10, 10, 15],
			"maxLevel": 5,
			"spriteFrame": 2,
		},
		4: { ##Amount
			"type": "stat",
			"cardName": "Amount",
			"description": "+1 Bullet",
			"levels": [1, 1, 1],
			"maxLevel": 3,
			"spriteFrame": 3,
		},
		5: { ##Health
			"type": "stat",
			"cardName": "Health",
			"description": "+10 HP",
			"levels": [10, 10, 15, 15, 20],
			"maxLevel": 5,
			"spriteFrame": 4,
		},
		6: { ##Fireball
			"type": "ability",
			"cardName": "Fireball",
			"description": "Launches a fireball",
			"abilityId": 1, ##Matches AbilityService abilityDictionary key
			"levels": [],
			"maxLevel": 3,
			"spriteFrame": 5,
		},
		7: { ##Lightning
			"type": "ability",
			"cardName": "Lightning",
			"description": "Strikes with lightning",
			"abilityId": 2,
			"levels": [],
			"maxLevel": 3,
			"spriteFrame": 6,
		},
		8: { ##Poison
			"type": "ability",
			"cardName": "Poison",
			"description": "Spawns a poison cloud",
			"abilityId": 3,
			"levels": [],
			"maxLevel": 3,
			"spriteFrame": 7,
		},
		9: { ##Frost
			"type": "ability",
			"cardName": "Frost",
			"description": "Fires a frost projectile",
			"abilityId": 4,
			"levels": [],
			"maxLevel": 3,
			"spriteFrame": 8,
		},
	}

###Stat and ability library###

##===============================##
