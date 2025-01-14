extends PlayerState


var should_jump := false
var can_jump := false


func exit() -> void:
	should_jump = false
	can_jump = false


func physics_update(delta: float) -> void:
	handle_gamepad_look()
	handle_movement()
	handle_gravity(delta)
	
	var input_direction = Input.get_vector("strafe_left", "strafe_right", "move_backward", "move_forward")
	
	if Input.is_action_just_pressed("jump"):
		if can_jump:
			transition("Jump")
		buffer_jump()
	
	if player.is_on_floor():
		if should_jump:
			transition("Jump")
		elif player.velocity == Vector3.ZERO:
			transition("Idle")
		elif input_direction != Vector2.ZERO:
			transition("Run")


func input_update(event) -> void:
	super(event)
	handle_mouse_look(event)


func buffer_jump() -> void:
	should_jump = true
	await get_tree().create_timer(player.jump_buffer).timeout
	should_jump = false


func coyote_time() -> void:
	can_jump = true
	await get_tree().create_timer(player.coyote_time).timeout
	can_jump = false
