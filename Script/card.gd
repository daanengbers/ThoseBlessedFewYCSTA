extends Node2D

var cardnr = 1

func _ready():
	randomize()
	cardnr = randi()%9 + 1
	setcardstats()

func _process(delta):
	pass

func rerandomizecard():
	cardnr = randi()%9 + 1

func setcardstats():
	# Common spells
	if cardnr == 1:
		actuallysetstats(0,"Strong Soul","+1 Attack",0)
	if cardnr == 2:
		actuallysetstats(0,"Nimble Soul","+5 Speed",1)
	if cardnr == 3:
		actuallysetstats(0,"Speedy Spectre","-2% Cooldown",2)
	if cardnr == 4:
		actuallysetstats(0,"Healthy Hauntings","+2 Max HP",4)
	if cardnr == 5:
		actuallysetstats(1,"Fireball","Strong and fast projectile",5)
	if cardnr == 6:
		actuallysetstats(1,"Lightningbolt","projectile that passes through",6)
	# Uncommon spells
	
	
	
	
	#if cardnr == 5:
	#	actuallysetstats(0,"Numerous Spells","+1 Attack Amount",3)
	#if cardnr == 6:
	#	actuallysetstats(0,"Hard-Hitting Souls","+2 Attack",0)
	if cardnr == 7:
		actuallysetstats(0,"Quick Souls","+7 Speed",1)
	if cardnr == 8:
		actuallysetstats(0,"Adrenaline Spectres","-4% Cooldown",2)
	if cardnr == 9:
		actuallysetstats(0,"Impenetrable Soul","+3 Max HP",4)
	# Rare spells
	if cardnr == 10:
		actuallysetstats(0,"","",1)
	if cardnr == 11:
		actuallysetstats(0,"","",1)
	if cardnr == 12:
		actuallysetstats(0,"","",1)
	if cardnr == 13:
		actuallysetstats(0,"","",1)
	if cardnr == 14:
		actuallysetstats(0,"","",1)
	
	

func selectcard(s_button):
	$eh/Anim.play("select")
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
	
	
	
	
	
	
	
	
	
	
	
	
	

func addstats(atk,spd,cdn,amt,hp):
	Globalsettings.currentrun_extraattack += atk
	Globalsettings.currentrun_extraspeed += spd
	if Globalsettings.currentrun_minuscooldown < 95:
		Globalsettings.currentrun_minuscooldown += cdn
	else:
		Globalsettings.currentrun_minuscooldown = 95
	Globalsettings.currentrun_extrabullets += amt
	Globalsettings.currentrun_extrahealth += hp
	if hp >= 1:
		get_tree().call_group("crowd_m", "update_hp")
	
	

func actuallysetstats(cardcolor,cardname,carddescription,cardimg):
	$eh/Spellcards.frame = cardcolor
	$eh/Cardname.set_text(str(cardname))
	$eh/Carddescription.set_text(str(carddescription))
	$eh/UpgradeIcons.frame = cardimg
