extends PlayerState


@export var footstep_distance : float = 1.0

@onready var fall: Node = $"../Fall"
@onready var distance_travelled := footstep_distance


var previous_step_position : Vector3 = Vector3.ZERO
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
	
	#if player.global_position.distance_to(previous_step_position) >= footstep_distance:
		#print(player.global_position.distance_to(previous_step_position))
		#previous_step_position = player.global_position
		#Audio.play(footstep_sound, "SFX")
	if distance_travelled >= footstep_distance:
		distance_travelled = 0.0
		Audio.play(player.sound_footstep, "SFX")
	else:
		distance_travelled += player.global_position.distance_to(previous_step_position)
	previous_step_position = player.global_position



func input_update(event) -> void:
	super(event)
	handle_mouse_look(event)
