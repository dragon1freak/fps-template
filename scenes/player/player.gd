extends BaseCharacterClass
class_name PlayerClass


@export var weapons : Array[WeaponConfig] = []


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
@export_group("")


@onready var pivot = $Pivot
@onready var movement_state: StateMachine = $MovementState
@onready var interactor: RayCast3D = %Interactor
@onready var main_camera: Camera3D = %MainCamera
@onready var container: Node3D = %Container
@onready var shot_cast: RayCast3D = %ShotCast
@onready var crosshair: TextureRect = $PlayerHUD/Control/Crosshair
@onready var right_hand: WeaponSlot = %RightHand


var rotation_target : Vector3
var previous_rotation : float = 0.0 # Stores the last frames rotation_target.y to determine the amount of tilt

var weapon_index := 0
var current_weapon 

var can_shoot := true


func _ready() -> void:
	initiate_change_weapon(0)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_weapon"):
		initiate_change_weapon(wrap(weapon_index + 1, 0, weapons.size()))
	
	if can_shoot and Input.is_action_just_pressed("shoot"):
		right_hand.set_is_shooting(true)
	elif Input.is_action_just_released("shoot"):
		right_hand.set_is_shooting(false)


func _physics_process(delta):
	# Handles rotations if a rotation target exists
	if rotation_target:
		pivot.rotation.x = lerp_angle(pivot.rotation.x, rotation_target.x, delta * 25) # Rotate camera pivot up and down
		rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25) # Rotate player left and right
		main_camera.rotation.z = lerp_angle(main_camera.rotation.z, clamp(rotation_target.y - previous_rotation, -0.15, 0.15) * 25 * delta, delta * 10) # Slight camera tilt based on rotation speed
		previous_rotation = rotation_target.y
	
	container.position = lerp(container.position, (basis.inverse() * -velocity / 50).clampf(-0.05, 0.05), delta * 5) # Moves the weapon container around during movement
	move_and_slide()


func damage(amount: int, dealer) -> void:
	if movement_state.current_state.has_method("handle_damage"):
		movement_state.current_state.handle_damage(amount, dealer)


func kill() -> void:
	print("dead")


var tween : Tween
func initiate_change_weapon(index):
	right_hand.set_is_shooting(false)

	weapon_index = index
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(container, "position", container.position + Vector3(0, -0.5, 0), 0.1)
	tween.tween_callback(change_weapon) # Changes the model


# Switches the weapon model (off-screen)
func change_weapon():
	current_weapon = weapons[weapon_index]
	
	right_hand.set_weapon(current_weapon)
	
	crosshair.texture = current_weapon.crosshair
