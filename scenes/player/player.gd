extends BaseCharacterClass
class_name PlayerClass


@export var coyote_time := 0.1
@export var jump_buffer := 0.1
@export var jump_cancel_strength := 400.0

@export var mouse_sensitivity : float = 3.0
@export var gamepad_sensitivity := 0.075


@onready var pivot = $Pivot
@onready var movement_state: StateMachine = $MovementState
@onready var interactor: RayCast3D = %Interactor

var rotation_target : Vector3
var input_mouse : Vector2

func _ready() -> void:
	interactor.can_interact_changed.connect(_on_interact_change)

func _physics_process(delta):
	# Rotation
	if rotation_target:		
		pivot.rotation.x = lerp_angle(pivot.rotation.x, rotation_target.x, delta * 25)
		rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
	
	move_and_slide()


func damage(amount: int, dealer) -> void:
	if movement_state.current_state.has_method("handle_damage"):
		movement_state.current_state.handle_damage(amount, dealer)


func kill() -> void:
	print("dead")


func _on_interact_change(show: bool) -> void:
	print(show)
