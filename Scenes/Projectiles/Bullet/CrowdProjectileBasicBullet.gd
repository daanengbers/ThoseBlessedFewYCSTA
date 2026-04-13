extends ProjectileBase

###Basic functionality handled by base "ProjectileBase" class###

##===============================##

###Signals###

func _on_hitbox_area_entered(area):
	if "HURTbox_Enemy" in area.name or "Cage" in area.name:
		OnHitEnemy(area.get_parent())

func _on_queue_timer_timeout():
	queue_free()

###Signals###

##===============================##
