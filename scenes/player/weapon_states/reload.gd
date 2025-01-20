extends WeaponState



func enter(_t) -> void:
	super(_t)
	do_reload()


func do_reload() -> void:
	# Play reload sounds
	
	await get_tree().create_timer(current_weapon.reload_time).timeout
	
	current_weapon.current_magazine = current_weapon.max_magazine_size
	
	if target.is_shooting:
		return transition("shoot")
	else:
		return transition("idle")
