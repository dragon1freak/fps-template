extends WeaponState


var shoot_timer : SceneTreeTimer


func enter(_t) -> void:
	super(_t)
	do_shoot()


func exit() -> void:
	if shoot_timer.timeout.is_connected(_post_shoot):
		shoot_timer.timeout.disconnect(_post_shoot)
	shoot_timer = null


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload") and current_weapon and current_weapon.current_magazine < current_weapon.max_magazine_size:
		if shoot_timer:
			Utils.signal_disconnect_all(shoot_timer.timeout)
		transition("reload")


## Simple shoot function.  Plays the shoot sound, decrements the current magazine by one, and sets
## a timer to the weapon's fire_rate.  When the timer is finished, it calls the _post_shoot() function
func do_shoot() -> void:
	target.on_shoot()
	if current_weapon.sound_shoot:
		Audio.play(current_weapon.sound_shoot, "SFX")
	current_weapon.current_magazine -= 1
	
	if target.shot_cast:
		var shot_cast = target.shot_cast
		for n in current_weapon.shot_count:
			shot_cast.target_position.x = randf_range(-current_weapon.spread, current_weapon.spread)
			shot_cast.target_position.y = randf_range(-current_weapon.spread, current_weapon.spread)
			
			shot_cast.force_raycast_update()
			
			# If the raycast isnt colliding, we continue the loop
			if !shot_cast.is_colliding(): continue
			
			var collision = shot_cast.get_collider()
			
			# Call the damage function on the collider if it exists
			if collision.has_method("_damage"):
				collision._damage(current_weapon.damage)
			
			# Creating an impact animation if an impact scene exists on the weapon config
			if current_weapon.impact:
				var impact_instance = current_weapon.impact.instantiate()
				impact_instance.position = shot_cast.get_collision_point() 
				get_tree().root.add_child(impact_instance)
	
	shoot_timer = get_tree().create_timer(current_weapon.fire_rate)
	shoot_timer.timeout.connect(_post_shoot)


## Handles any post shooting logic like playing the weapon's sound_post_shoot sound, transitioning to the 
## reload state if the magazine is empty, and shooting again if the weapon is automatic and the WeaponSlot
## is shooting
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
