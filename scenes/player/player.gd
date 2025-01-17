extends BaseCharacterClass
class_name PlayerClass


@export_group("Controls")
## Base sensitivity
@export var mouse_sensitivity : float = 3.0
@export var gamepad_sensitivity := 0.075
@export_group("")


@export_group("Movement")
## Force used to stop the jump if the jump action is released mid jump.  
## Set to zero to disable this.
@export var jump_cancel_strength : float = 20.0
## Amount of time the player can still jump after leaving a ledge
@export_range(0, 1.0) var coyote_time : float = 0.1
## Amount of time the player can trigger the jump action before landing and still jump
@export_range(0, 1.0) var jump_buffer : float = 0.1


@onready var pivot = $Pivot
@onready var movement_state: StateMachine = $MovementState
@onready var interactor: RayCast3D = %Interactor
@onready var main_camera: Camera3D = %MainCamera
@onready var container: Node3D = %Container


var rotation_target : Vector3
var previous_rotation : float = 0.0 # Stores the last frames rotation_target.y to determine the amount of tilt


func _physics_process(delta):
	# Handles rotations if a rotation target exists
	if rotation_target:
		pivot.rotation.x = lerp_angle(pivot.rotation.x, rotation_target.x, delta * 25) # Rotate camera pivot up and down
		rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25) # Rotate player left and right
		main_camera.rotation.z = lerp_angle(main_camera.rotation.z, clamp(rotation_target.y - previous_rotation, -0.15, 0.15) * 25 * delta, delta * 5) # Slight camera tilt based on rotation speed

		previous_rotation = rotation_target.y
	container.position = lerp(container.position, (basis.inverse() * -velocity / 50).clampf(-0.05, 0.05), delta * 5)
	move_and_slide()


func damage(amount: int, dealer) -> void:
	if movement_state.current_state.has_method("handle_damage"):
		movement_state.current_state.handle_damage(amount, dealer)


func kill() -> void:
	print("dead")
