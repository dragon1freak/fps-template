extends PlayerState


## If true, the player jumps when landing
var should_jump := false
## If true, the player can jump during the fall
var can_jump := false


func exit() -> void:
	should_jump = false
	can_jump = false


func physics_update(delta: float) -> void:
	handle_gamepad_look()
	
	# Override this if you want air movement to function differently than ground movement
	handle_movement()
	handle_gravity(delta)
	
	var input_direction = Input.get_vector("strafe_left", "strafe_right", "move_backward", "move_forward")
	
	if Input.is_action_just_pressed("jump"):
		if can_jump:
			transition("Jump")
		buffer_jump()
	
	if player.is_on_floor():
		Audio.play(player.sound_land, "SFX", 0) # Play the landing sound when on the floor
		if should_jump:
			transition("Jump")
		elif player.velocity == Vector3.ZERO:
			transition("Idle")
		elif input_direction != Vector2.ZERO:
			transition("Run")


func input_update(event) -> void:
	super(event)
	handle_mouse_look(event)


## If the jump button is pressed while falling, the input is buffered so if the player lands during that time they jump
func buffer_jump() -> void:
	should_jump = true
	await get_tree().create_timer(player.jump_buffer).timeout
	should_jump = false


## Coyote time allows a window during the fall the player can still jump, makes jumping at ledges feel better
func coyote_time() -> void:
	can_jump = true
	await get_tree().create_timer(player.coyote_time).timeout
	can_jump = false
