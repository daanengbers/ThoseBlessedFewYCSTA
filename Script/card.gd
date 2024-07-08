extends Node2D

var cardnr = 1

func _ready():
	randomize()
	cardnr = randi()%12 + 1
	setcardstats()

func rerandomizecard():
	cardnr = randi()%12 + 1

func setcardstats():
	# Common spells
	if cardnr == 1:
		actuallysetstats(0,"Strong Soul","+1 Attack",0)
	if cardnr == 2:
		actuallysetstats(0,"Nimble Soul","+5 Speed",1)
	if cardnr == 3:
		if Globalsettings.currentrun_minuscooldown >= 80:
			cardnr = 50
		else:
			actuallysetstats(0,"Speedy Spectre","-2% Cooldown",2)
	if cardnr == 4:
		actuallysetstats(0,"Healthy Hauntings","+2 Max HP",4)
	if cardnr == 5:
		actuallysetstats(1,"Fireball","Strong and fast projectile",5)
	if cardnr == 6:
		actuallysetstats(1,"Lightningbolt","projectile that passes through",6)
	# Uncommon spells
	if cardnr == 7:
		actuallysetstats(0,"Quick Souls","+7 Speed",1)
	if cardnr == 8:
		if Globalsettings.currentrun_minuscooldown >= 80:
			cardnr = 50
		else:
			actuallysetstats(0,"Adrenaline Spectres","-4% Cooldown",2)
	if cardnr == 9:
		actuallysetstats(0,"Impenetrable Soul","+3 Max HP",4)
	if cardnr == 10:
		actuallysetstats(2,"Birth of a soul","+1 Meebling",13)
	if cardnr == 11:
		actuallysetstats(1,"Poison Cloud","lingering cloud of damage",7)
	if cardnr == 12:
		actuallysetstats(1,"Frost Flake","Slows down hit enemies",8)
	# Rare spells
	if cardnr == 13:
		actuallysetstats(0,"Hard-Hitting Souls","+2 Attack",0)
	if cardnr == 14:
		actuallysetstats(0,"Supersonic Souls","+10 Speed",1)
	if cardnr == 15:
		actuallysetstats(0,"","",1)
	if cardnr == 16:
		actuallysetstats(0,"","",1)
	if cardnr == 17:
		actuallysetstats(0,"","",1)
	
	if cardnr == 50:
		actuallysetstats(2,"Develish Deal","Reset Cooldown. +1 bullet",14)
	

func selectcard(s_button):
	$eh/Anim.play("select")
	$eh/Select.play()
	if cardnr == 1:
		addstats(1,0,0,0,0)
	if cardnr == 2:
		addstats(0,5,0,0,0)
	if cardnr == 3:
		addstats(0,0,2,0,0)
	if cardnr == 4:
		addstats(0,0,0,0,2)
	if cardnr == 5:
		if s_button == 1:
			Globalsettings.g_spell1 = 1
		if s_button == 2:
			Globalsettings.g_spell2 = 1
		if s_button == 3:
			Globalsettings.g_spell3 = 1
		if s_button == 4:
			Globalsettings.g_spell4 = 1
	if cardnr == 6:
		if s_button == 1:
			Globalsettings.g_spell1 = 2
		if s_button == 2:
			Globalsettings.g_spell2 = 2
		if s_button == 3:
			Globalsettings.g_spell3 = 2
		if s_button == 4:
			Globalsettings.g_spell4 = 2
	if cardnr == 7:
		addstats(0,7,0,0,0)
	if cardnr == 8:
		addstats(0,0,4,0,0)
	if cardnr == 9:
		addstats(0,0,0,0,3)
	if cardnr == 10:
		pass
	if cardnr == 11:
		if s_button == 1:
			Globalsettings.g_spell1 = 3
		if s_button == 2:
			Globalsettings.g_spell2 = 3
		if s_button == 3:
			Globalsettings.g_spell3 = 3
		if s_button == 4:
			Globalsettings.g_spell4 = 3
	if cardnr == 12:
		if s_button == 1:
			Globalsettings.g_spell1 = 4
		if s_button == 2:
			Globalsettings.g_spell2 = 4
		if s_button == 3:
			Globalsettings.g_spell3 = 4
		if s_button == 4:
			Globalsettings.g_spell4 = 4
	
	if cardnr == 50:
		Globalsettings.currentrun_minuscooldown = 0
		addstats(0,0,0,1,0)
	
	
	
	
	
	
	
	
	

func addstats(atk,spd,cdn,amt,hp):
	Globalsettings.currentrun_extraattack += atk
	Globalsettings.currentrun_extraspeed += spd
	if (Globalsettings.currentrun_minuscooldown + cdn) < 80:
		Globalsettings.currentrun_minuscooldown += cdn
	else:
		Globalsettings.currentrun_minuscooldown = 80
	Globalsettings.currentrun_extrabullets += amt
	Globalsettings.currentrun_extrahealth += hp
	if hp >= 1:
		get_tree().call_group("crowd_m", "update_hp")
	
	

func actuallysetstats(cardcolor,cardname,carddescription,cardimg):
	$eh/Spellcards.frame = cardcolor
	$eh/Cardname.set_text(str(cardname))
	$eh/Carddescription.set_text(str(carddescription))
	$eh/UpgradeIcons.frame = cardimg
