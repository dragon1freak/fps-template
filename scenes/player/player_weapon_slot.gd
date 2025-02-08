extends WeaponSlot
class_name PlayerWeaponSlot
## WeaponSlot that is specific to the player.  This allows us to do player specific things like
## animate swapping the weapon and setting the weapon meshes to the correct render layer


## Reference to the player object
@onready var player : PlayerClass = get_tree().get_first_node_in_group("player")

## Target position for the ModelContainer node
var model_container_position := Vector3.ZERO

## The tween used to animate swapping the weapon.  Moves the weapon out of frame before swapping and back into frame afterwards
var tween : Tween


func _physics_process(delta: float) -> void:
	# Moves the weapon container around during movement
	model_container.position = lerp(model_container.position, model_container_position + (player.basis.inverse() * -player.velocity / 50).clampf(-0.05, 0.05), delta * 5)


## Sets the weapon to the new WeaponConfig.  Animates the weapon being swapped using a tweener.
func set_weapon(new_weapon : WeaponConfig) -> void:
	weapon_state.is_active = false
	var previous_weapon = current_weapon
	current_weapon = new_weapon

	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(model_container, "position", model_container.position + Vector3(0, -0.5, 0), 0.15)
	await tween.finished
	
	_swap_model(new_weapon)
	_swap_muzzle_flash(new_weapon)
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(model_container, "position", model_container_position, 0.15)
	await tween.finished

	# Set weapon data
	shot_cast.target_position = Vector3(0, 0, -1) * new_weapon.max_range
	
	# If the WeaponStateConfig resource is different than the previous one, change out the states
	if previous_weapon == null or previous_weapon.states != new_weapon.states:
		weapon_state.set_states(new_weapon.states.get_states())
	else:
		weapon_state.reset_state()
	
	weapon_state.is_active = true

	return


## Swaps the models in ModelContainer to the new weapon models and sets them to the correct render layer
func _swap_model(new_weapon : WeaponConfig) -> void:
	model_container.rotation = Vector3.ZERO
	# Step 1. Remove previous weapon model(s)
	for n in model_container.get_children():
		model_container.remove_child(n)
	
	# Step 2. Place new weapon model
	weapon_model = new_weapon.model.instantiate()
	model_container.add_child(weapon_model)
	
	model_container_position = new_weapon.position
	weapon_model.rotation_degrees = new_weapon.rotation
	
	# Step 3. Set model to only render on layer 2 (the weapon camera)
	for child in weapon_model.find_children("*", "MeshInstance3D"):
		child.layers = 2



## Anything the weapon slot should do on shoot like animate the model or kick.  This could also be done
## at the state machine level by affecting the state target properties, but a single method call 
## on the target may be easier.
func on_shoot() -> void:
	model_container.position.z += current_weapon.kick
	if muzzle_flash:
		muzzle_flash.stop()
		muzzle_flash.rotation_degrees.z += randf_range(-45.0, 45.0)
		muzzle_flash.play()


## The below functions are like the above on_shoot(), but for reload states.
var reload_tween : Tween
func start_reload() -> void:
	# This is just a simple reload animation, change this how you like
	if reload_tween:
		reload_tween.kill()
	reload_tween = get_tree().create_tween()
	reload_tween.tween_property(model_container, "rotation_degrees", Vector3(-15, 0, 0), 0.2)


func on_reload_step() -> void:
	pass


func end_reload() -> void:
	if reload_tween:
		reload_tween.kill()
	reload_tween = get_tree().create_tween()
	reload_tween.tween_property(model_container, "rotation_degrees", Vector3(0, 0, 0), 0.2)


func cancel_reload() -> void:
	if reload_tween:
		reload_tween.kill()
	model_container.rotation = Vector3.ZERO
