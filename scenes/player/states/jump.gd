extends PlayerState


func enter(_p) -> void:
	super(_p)
	apply_jump(player.current_stats.jump_strength)
	Audio.play(player.sound_jump, "SFX")


func physics_update(delta: float) -> void:
	handle_gamepad_look()
	
	# Override this if you want air movement to function differently than ground movement
	handle_movement()
	handle_gravity(delta)
	
	# Transitioning to the Fall state instead of straight to the Idle state allows for handling landing
	if player.velocity.y < 0 or player.is_on_floor():
		transition("Fall")
	
	if Input.get_action_strength("jump") == 0.0 and player.velocity.y > 0:
		cancel_jump(delta)


func input_update(event) -> void:
	super(event)
	handle_mouse_look(event)


## If jump is released before reaching the top of the jump, the jump is cancelled using the [param JUMP_CANCEL_FORCE] and delta
func cancel_jump(delta: float) -> void:
	player.velocity.y -= player.jump_cancel_strength * sign(player.velocity.y) * delta
