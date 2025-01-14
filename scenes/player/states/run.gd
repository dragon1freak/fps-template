extends PlayerState


@onready var fall: Node = $"../Fall"


func physics_update(delta: float) -> void:
	handle_gamepad_look()
	handle_movement()
	handle_gravity(delta)

	
	if player.velocity == Vector3.ZERO:
		transition("Idle")
	
	if player.velocity.y < 0 and not player.is_on_floor():
		transition("Fall")
		fall.coyote_time()
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition("Jump")


func input_update(event) -> void:
	super(event)
	handle_mouse_look(event)
