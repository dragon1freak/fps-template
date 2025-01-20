extends WeaponState


func update(delta) -> void:
	if target and target.is_shooting:
		transition("shoot")
	
	if Input.is_action_just_pressed("reload") and current_weapon.current_magazine < current_weapon.max_magazine_size:
		transition("reload")
