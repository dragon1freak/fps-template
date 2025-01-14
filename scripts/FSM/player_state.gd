extends State
class_name PlayerState
## Base state class for the player states
##
## Handles default functionality like basic movement, gravity, etc.
## If any of this functionality needs to be changed per state, you can
## just ignore the default function and handle it as you need.


var player : PlayerClass


func enter(new_target: Node) -> void:
	print(self.name)
	if new_target is PlayerClass:
		player = new_target


## Default movement function util for the player states
func handle_movement(can_sprint: bool = false) -> void:
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var current_speed = player.current_stats.speed
	if direction:
		if can_sprint and Input.is_action_pressed("sprint"):
			current_speed *= 1.5
		player.velocity.x = direction.x * current_speed
		player.velocity.z = direction.z * current_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, current_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, current_speed)


## Default gravity function util for the player states
func handle_gravity(delta: float) -> void:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity.y -= player.current_stats.gravity * delta


## Handles gamepad aiming
func handle_gamepad_look() -> void:
	# Rotation for controller
	var rotation_input := Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	
	player.rotation_target -= Vector3(-rotation_input.y, -rotation_input.x, 0).limit_length(1.0) * player.gamepad_sensitivity
	player.rotation_target.x = clamp(player.rotation_target.x, deg_to_rad(-90), deg_to_rad(90))


## Handles mouse aiming
func handle_mouse_look(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		player.rotation_target.y -= event.relative.x / player.mouse_sensitivity / 100
		player.rotation_target.x -= event.relative.y / player.mouse_sensitivity / 100
		player.rotation_target.x = clamp(player.rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
		player.input_mouse = event.relative / player.mouse_sensitivity 


## Default damage function, simply subtracts the amount from the current health value
func handle_damage(amount: int, _dealer) -> void:
	player.current_stats.health -= amount
	if player.current_stats.health <= 0:
		player.kill()


## Input update function handling mouse capture, should probably be called 
func input_update(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func apply_velocity(force : float, direction : Vector3) -> void:
	player.velocity += force * direction


func apply_jump(force : float, direction := Vector3.UP, stop_velocity := true) -> void:
	if stop_velocity:
		player.velocity.y = 0
	apply_velocity(force, direction)


func transition(target_state : String) -> void:
	transitioned.emit(self, target_state)
