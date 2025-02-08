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

@export_group("Sounds", "sound_")
## Sound played by the Run state for footsteps
@export var sound_footstep : AudioStream = preload("res://sounds/player/footstep.ogg")
## Sound played by the Jump state for jumping
@export var sound_jump : AudioStream = preload("res://sounds/player/jump.ogg")
## Sound played by the Fall state when landing
@export var sound_land : AudioStream = preload("res://sounds/player/land.ogg")
@export_group("")


@onready var pivot = $Pivot
@onready var movement_state: StateMachine = $MovementState
@onready var interactor: RayCast3D = %Interactor
@onready var main_camera: Camera3D = %MainCamera
@onready var container: Node3D = %Container
@onready var crosshair: TextureRect = %Crosshair
@onready var right_hand: WeaponSlot = %RightHand


var rotation_target : Vector3 # Rotation target for the player and the main camera
var previous_velocity := Vector3.ZERO # Stores the previous frames velocity

var weapon_index := 0
var current_weapon

var can_shoot := true


func _ready() -> void:
	change_weapon(0)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_weapon"):
		change_weapon(wrap(weapon_index + 1, 0, weapons.size()))
	
	if can_shoot and Input.is_action_just_pressed("shoot"):
		right_hand.set_is_shooting(true)
	elif Input.is_action_just_released("shoot"):
		right_hand.set_is_shooting(false)


func _physics_process(delta):
	# Handles rotations if a rotation target exists
	if rotation_target:
		pivot.rotation.x = lerp_angle(pivot.rotation.x, rotation_target.x, delta * 25) # Rotate camera pivot up and down
		rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25) # Rotate player left and right
	
	main_camera.position.y = lerp(main_camera.position.y, 0.0, delta * 5)
	
	# Slight camera movement when landing
	if is_on_floor() and previous_velocity.y != 0:
		main_camera.position.y = -0.1
	
	previous_velocity = velocity
	move_and_slide()


## Pass damage taken on to the current movement state.  We do this
## so we can handle damage per state, allowing for movements like dashes
## or such to handle damage differently
func damage(amount: int, dealer) -> void:
	if movement_state.current_state.has_method("handle_damage"):
		movement_state.current_state.handle_damage(amount, dealer)


## Called when the player is dead, typically called by the current movement state if
## health is at or below 0
func kill() -> void:
	print("dead")


## Switches the current weapon based on the passed index
func change_weapon(index : int):
	can_shoot = false
	right_hand.set_is_shooting(false)
	
	weapon_index = index
	current_weapon = weapons[weapon_index]
		
	# Wait for the weapon slot to change the weapon
	await right_hand.set_weapon(current_weapon)
	
	crosshair.texture = current_weapon.crosshair
	
	can_shoot = true
	if can_shoot and Input.is_action_pressed("shoot"):
		right_hand.set_is_shooting(true)
