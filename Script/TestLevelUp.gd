extends Node

##@onready var HPStat = preload("res://Scenes/NewLevelUpSystemTest/HP_Stat.tscn")
##@onready var ATTACKStat = preload("res://Scenes/NewLevelUpSystemTest/ATTACK_Stat.tscn")

@onready var HPStat = $HpStat
@onready var ATTACKStat = $ATTACKStat

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	var BeginningStats = [HPStat.statID, ATTACKStat.statID]
	var Weights = PackedFloat32Array([1.,1])
	print(BeginningStats[rng.rand_weighted(Weights)])
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
