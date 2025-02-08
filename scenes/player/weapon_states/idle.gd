extends WeaponState


func update(delta) -> void:
	# We override the state's current weapon here to guarantee the current weapon is actually the current one
	current_weapon = target.current_weapon
	
	if current_weapon and current_weapon.current_magazine <= 0:
		transition("reload")
	if Input.is_action_just_pressed("reload") and current_weapon.current_magazine < current_weapon.max_magazine_size:
		transition("reload")
	
	if current_weapon and current_weapon.current_magazine > 0 and target and target.is_shooting:
		transition("shoot")
