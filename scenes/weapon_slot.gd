extends Node3D
class_name WeaponSlot
## Node to hold and manage weapons using the WeaponConfig set at
## current_weapon
##
## This manages the weapon's state, raycast, and any other weapon specific logic.
## Keeping this separate from the equipped entity such as an enemy or player means
## you can just add this to your scene and the WeaponState state machine should handle
## the rest.  This is entirely dependant on the states you pass in the weapon config though.

## Weapon currently in the weapon slot
@export var current_weapon : WeaponConfig


## Container that holds the models
@onready var model_container: Node3D = %ModelContainer
## Raycast used when shooting the gun
@onready var shot_cast: RayCast3D = %ShotCast
## State machine for the weapon state
@onready var weapon_state: StateMachine = %WeaponState


## Used to tell the state machine if the weapon should be firing
var is_shooting := false

var muzzle_flash
var weapon_model


func _ready() -> void:
	weapon_state.state_target = self # Set the state machine target


## Sets the current weapon to the passed WeaponConfig.  If the new WeaponStateConfig is 
## different than the previous weapon's, we set the new states on the state machine
func set_weapon(new_weapon : WeaponConfig) -> void:
	_swap_model(new_weapon)
	_swap_muzzle_flash(new_weapon)
	# Set weapon data
	shot_cast.target_position = Vector3(0, 0, -1) * new_weapon.max_range
	
	# If the WeaponStateConfig resource is different than the previous one, change out the states
	if current_weapon == null or current_weapon.states != new_weapon.states:
		weapon_state.set_states(new_weapon.states.get_states())
	
	current_weapon = new_weapon


## Swaps the models in the ModelContainer node
func _swap_model(new_weapon : WeaponConfig) -> void:
	# Step 1. Remove previous weapon model(s)
	for n in model_container.get_children():
		model_container.remove_child(n)
	
	# Step 2. Place new weapon model
	weapon_model = new_weapon.model.instantiate()
	model_container.add_child(weapon_model)
	
	model_container.position = new_weapon.position
	weapon_model.rotation_degrees = new_weapon.rotation


func _swap_muzzle_flash(new_weapon : WeaponConfig) -> void:
	# Step 3. Set up muzzle flash
	if muzzle_flash != null:
		muzzle_flash.queue_free()
	
	if new_weapon.muzzle_flash:
		muzzle_flash = new_weapon.muzzle_flash.instantiate()
		model_container.add_child(muzzle_flash)
		muzzle_flash.position = new_weapon.muzzle_position
		muzzle_flash.scale = new_weapon.muzzle_scale


func set_is_shooting(value : bool) -> void:
	is_shooting = value


## Anything the weapon slot should do on shoot like animate the model or kick.  This could also be done
## at the state machine level by affecting the state target properties, but a single method call 
## on the target may be easier.
func on_shoot() -> void:
	pass

## The below functions are like the above on_shoot(), but for reload states.
func start_reload() -> void:
	pass


func on_reload_step() -> void:
	pass


func end_reload() -> void:
	pass
