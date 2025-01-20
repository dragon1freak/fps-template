extends Node3D
class_name WeaponSlot


@export var current_weapon : WeaponConfig


@onready var model_container: Node3D = %ModelContainer
@onready var shot_cast: RayCast3D = %ShotCast
@onready var weapon_state: StateMachine = %WeaponState


var is_shooting := false


func _ready() -> void:
	weapon_state.state_target = self


func set_weapon(new_weapon : WeaponConfig) -> void:
	current_weapon = new_weapon
	
	# Step 1. Remove previous weapon model(s)
	for n in model_container.get_children():
		model_container.remove_child(n)
	
	# Step 2. Place new weapon model
	var weapon_model = current_weapon.model.instantiate()
	model_container.add_child(weapon_model)
	
	model_container.position = current_weapon.position
	weapon_model.rotation_degrees = current_weapon.rotation
	
	# Step 3. Set model to only render on layer 2 (the weapon camera)
	for child in weapon_model.find_children("*", "MeshInstance3D"):
		child.layers = 2
	
	# Set weapon data
	shot_cast.target_position = Vector3(0, 0, -1) * current_weapon.max_range


func set_is_shooting(value : bool) -> void:
	is_shooting = value
