extends Node

##References
@onready var crowdSimulator : CharacterBody2D = get_parent()

##Preload vars
var levelUpCardScene = preload("res://Scenes/CrowdSimulator/Services/LevelingService/LevelUpCardBase.tscn")

##Level vars
var xp : int = 0
var xpNeededToLevelUp : int = 5
var level : int = 1

##Upgrade tracking vars
var statLibrary : Dictionary = {}
var ownedUpgrades : Dictionary = {} ##Key = upgrade id, Value = current level
var maxStatSlots : int = 4
var maxAbilitySlots : int = 4

##UI vars
var shownCards : Array = []
var cardOptions : Array = []
var selectedCardIndex : int = 0
var isChoosingUpgrade : bool = false

##===============================##

###Standard functions###

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	LoadStats()

func _process(delta):
	pass

func _unhandled_input(event):
	if isChoosingUpgrade:
		HandleCardInput(event)

###Standard functions###

##===========================================##
##===========================================##
##              FUNCTIONALITY                ##
##===========================================##
##===========================================##

###XP and leveling###

##Adds xp to the bar from various sources
func GetXp(amount : int):
	xp += amount
	Globalsettings.global_xp = xp
	while xp >= xpNeededToLevelUp:
		xp -= xpNeededToLevelUp
		Globalsettings.global_xp = xp
		LevelUp()

##When the bar is full, trigger a level up
func LevelUp():
	level += 1
	IncreaseXpThreshold()
	
	var options = GetAvailableUpgrades()
	if options.size() == 0:
		return
	
	ShowLevelUpChoices(options)
	get_tree().paused = true

##Increases the xp needed to level up based on the current level
func IncreaseXpThreshold():
	if level <= 10:
		xpNeededToLevelUp += 2
	elif level >= 11 and level <= 30:
		xpNeededToLevelUp += 3
	elif level >= 31 and level <= 50:
		xpNeededToLevelUp += 4
	elif level >= 51 and level <= 70:
		xpNeededToLevelUp += 5
	elif level >= 71 and level <= 90:
		xpNeededToLevelUp += 6
	elif level >= 91 and level <= 100:
		xpNeededToLevelUp += 7
	elif level >= 101:
		xpNeededToLevelUp += 10 + level * 2

###XP and leveling###

##===========================================##

###Upgrade pool and selection###

##Returns an array of upgrade dictionaries that are still available (not maxed)
func GetAvailableUpgrades():
	var pool = []
	for id in statLibrary.keys():
		var currentLevel : int = ownedUpgrades.get(id, 0)
		var maxLevel : int = statLibrary[id]["maxLevel"]
		if currentLevel < maxLevel:
			pool.append({
				"id": id,
				"cardName": statLibrary[id]["cardName"],
				"description": statLibrary[id]["description"],
				"currentLevel": currentLevel,
				"nextLevel": currentLevel + 1,
				"maxLevel": maxLevel,
			})
	return pool

##Picks n random unique upgrades from the pool
func PickNRandom(arr : Array, n : int):
	var pool = arr.duplicate()
	pool.shuffle()
	return pool.slice(0, min(n, pool.size()))

##Applies the chosen upgrade
func ApplyUpgrade(upgrade : Dictionary):
	var id = upgrade["id"]
	var nextLevel : int = upgrade["nextLevel"]
	ownedUpgrades[id] = nextLevel
	
	##Get the stat value for this level from the library
	var levelValues : Array = statLibrary[id]["levels"]
	var valueIndex : int = nextLevel - 1
	if valueIndex >= 0 and valueIndex < levelValues.size():
		var value = levelValues[valueIndex]
		ApplyStatEffect(id, value)

##Applies the actual stat effect to globalsettings or ability service
func ApplyStatEffect(id : int, value):
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
		##Add more stat/ability cases here

###Upgrade pool and selection###

##===========================================##

###Stat and ability library###

##Library to keep stat values and the amount they give for each level, as well as their max level
func LoadStats():
	statLibrary = {
		1: { ##Attack
			"cardName": "Attack",
			"description": "+5 Attack",
			"levels": [5, 5, 10, 10, 15],
			"maxLevel": 5,
			"spriteFrame": 0,
		},
		2: { ##Speed
			"cardName": "Speed",
			"description": "+2 Speed",
			"levels": [2, 2, 4, 4, 8],
			"maxLevel": 5,
			"spriteFrame": 1,
		},
		3: { ##Cooldown
			"cardName": "Cooldown",
			"description": "-5 Cooldown",
			"levels": [5, 5, 10, 10, 15],
			"maxLevel": 5,
			"spriteFrame": 2,
		},
		4: { ##Amount
			"cardName": "Amount",
			"description": "+1 Bullet",
			"levels": [1, 1, 1],
			"maxLevel": 3,
			"spriteFrame": 3,
		},
		5: { ##Health
			"cardName": "Health",
			"description": "+10 HP",
			"levels": [10, 10, 15, 15, 20],
			"maxLevel": 5,
			"spriteFrame": 4,
		},
		##Add abilities and evolved upgrades here
	}

###Stat and ability library###

##===========================================##
##===========================================##
##                   UI                      ##
##===========================================##
##===========================================##

###Card display###

##Shows the level up choices by instantiating card scenes
func ShowLevelUpChoices(options : Array):
	ClearExistingCards()
	cardOptions = PickNRandom(options, 3)
	shownCards = []
	
	##Calculate card positions centered on screen
	var cardCount = cardOptions.size()
	var cardSpacing = 80.0
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
func SetCardContent(card, upgrade : Dictionary):
	card.get_node("CardName").text = upgrade["cardName"]
	card.get_node("CardLevel").text = "Level " + str(upgrade["nextLevel"])
	card.get_node("CardDescription").text = upgrade["description"]
	
	##Set upgrade sprite if available
	if upgrade.has("id") and statLibrary.has(upgrade["id"]):
		var spriteFrame = statLibrary[upgrade["id"]].get("spriteFrame", 0)
		card.get_node("CardSpriteUpgrade").frame = spriteFrame
	
	##Set card base sprite depending on if its new or an upgrade
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
	
	##Position the arrow below the selected card
	var arrowOffset = Vector2(0, -60)
	var targetPos = shownCards[selectedCardIndex].position + arrowOffset
	
	##Move the arrow to the target position (snap, not gradual)
	var arrow = GetOrCreateArrow()
	arrow.visible = true
	arrow.position = targetPos

##Gets the arrow node, or creates one if it doesnt exist yet
func GetOrCreateArrow():
	var uiLayer = crowdSimulator.get_node("UI")
	if uiLayer.has_node("LevelUpArrow"):
		return uiLayer.get_node("LevelUpArrow")
	
	##Create arrow sprite using the same texture as pause menu arrow
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
	
	##Apply the chosen upgrade
	ApplyUpgrade(cardOptions[selectedCardIndex])
	
	##Clean up UI
	ClearExistingCards()
	
	##Hide arrow
	var arrow = GetOrCreateArrow()
	arrow.visible = false
	
	##Resume the game
	isChoosingUpgrade = false
	get_tree().paused = false

###Input handling###

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
