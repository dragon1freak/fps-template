extends WeaponState


func enter(_t) -> void:
	super(_t)
	do_shoot()


func do_shoot() -> void:
	print("bang")
	current_weapon.current_magazine -= 1
	await get_tree().create_timer(current_weapon.fire_rate).timeout
	
	if current_weapon.current_magazine <= 0:
		return transition("reload")
	
	if target.is_shooting and current_weapon.automatic:
		do_shoot()
	else:
		target.set_is_shooting(false)
		transition("idle")
