extends Node

##GlobalStats flat values

var globalStatsExtraDMG : int = 0
var globalStatsExtraHP : int = 0
var globalStatsExtraBOU : int  = 0
var globalStatsExtraAM : int = 0
var globalStatsExtraSPD : int = 0
var globalStatsExtraARM : int = 0
var globalStatsExtraRG : int = 0

##Globalstats percentages
var globalStatsPerCDR : float = 0.0
var globalStatsPerAS : float = 0.0
var globalStatsPerDUR : float = 0.0
var globalStatsPerLD : float = 0.0
var globalStatsPerXP : float = 0.0
var globalStatsPerCUR : float = 0.0

##===============================##

###Flat stat getters###

## Flat bonus damage
func GetStatDamage() -> int:
	return globalStatsExtraDMG

	## Flat bonus health
func GetStatHealth() -> int:
	return globalStatsExtraHP

## Bounce count
func GetStatBounce() -> int:
	return globalStatsExtraBOU

## Extra bullets count (0 = no extra)
func GetStatAmount() -> int:
	return globalStatsExtraAM

## Flat bonus movement speed
func GetStatMoveSpeed() -> int:
	return globalStatsExtraSPD

## Flat armor
func GetStatArmor() -> int:
	return globalStatsExtraARM

## Flat regen
func GetStatRegen() -> int:
	return globalStatsExtraRG

###Flat stat getters###

##===============================##

###Percentile stat getters###

## Ability CDR multiplier (1.0 = base, 0.8 = 20% faster)
func GetStatCDR() -> float:
	return maxf(0.1, 1.0 - globalStatsPerCDR * 0.01)

## Attack speed multiplier (1.0 = base, lower = faster cooldown)
func GetStatAttackSpeed() -> float:
	return maxf(0.1, 1.0 - globalStatsPerAS * 0.01)

## Duration multiplier (1.0 = base, 1.2 = 20% longer)
func GetStatDuration() -> float:
	return 1.0 + globalStatsPerDUR * 0.01

## Life drain as a fraction (0.0 to 1.0)
func GetStatLifeDrain() -> float:
	return globalStatsPerLD * 0.01

###Percentile stat getters###

##===============================##

#Implement XP and Curse later
