extends WeaponState



func enter(_t) -> void:
	super(_t)
	do_reload()


func do_reload() -> void:
	# Play reload sounds
	
	if current_weapon.sound_reload_start:
		Audio.play(current_weapon.sound_reload_start, "SFX")
	
	await get_tree().create_timer(current_weapon.reload_time / 2.0).timeout
	
	if current_weapon.sound_reload_step:
		Audio.play(current_weapon.sound_reload_step, "SFX")
	
	await get_tree().create_timer(current_weapon.reload_time / 2.0).timeout
	
	if current_weapon.sound_reload_end:
		Audio.play(current_weapon.sound_reload_end, "SFX")
	
	current_weapon.current_magazine = current_weapon.max_magazine_size
	
	if target.is_shooting:
		return transition("shoot")
	else:
		return transition("idle")
