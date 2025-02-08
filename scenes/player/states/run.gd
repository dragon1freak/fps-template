extends PlayerState

## Distance the player should move between footsteps
@export var footstep_distance : float = 1.0

## Get a reference to the Fall state so we can call coyote time
@onready var fall: Node = $"../Fall"
## Set the distance_travelled to the above footstep_distance
@onready var distance_travelled := footstep_distance

## Holds the position of the player at the previous frame
var previous_position : Vector3 = Vector3.ZERO


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
	
	# Play footstep sound if the player travels the footstep_distance
	if distance_travelled >= footstep_distance:
		distance_travelled = 0.0
		Audio.play(player.sound_footstep, "SFX")
	else:
		distance_travelled += player.global_position.distance_to(previous_position)
	previous_position = player.global_position


func input_update(event) -> void:
	super(event)
	handle_mouse_look(event)
