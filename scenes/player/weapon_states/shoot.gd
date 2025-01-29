extends WeaponState


func enter(_t) -> void:
	super(_t)
	do_shoot()


func exit() -> void:
	if shoot_timer.timeout.is_connected(_post_shoot):
		shoot_timer.timeout.disconnect(_post_shoot)
	shoot_timer = null


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload") and current_weapon.current_magazine < current_weapon.max_magazine_size:
		transition("reload")


var shoot_timer : SceneTreeTimer
func do_shoot() -> void:
	# Play shoot sounds
	if current_weapon.sound_shoot:
		Audio.play(current_weapon.sound_shoot, "SFX")
	current_weapon.current_magazine -= 1
	
	shoot_timer = get_tree().create_timer(current_weapon.fire_rate)
	shoot_timer.timeout.connect(_post_shoot)



func _post_shoot() -> void:
	if current_weapon.sound_post_shoot:
		Audio.play(current_weapon.sound_post_shoot, "SFX")
	
	if current_weapon.current_magazine <= 0:
		return transition("reload")
	
	if target.is_shooting and current_weapon.automatic:
		do_shoot()
	else:
		target.set_is_shooting(false)
		transition("idle")
