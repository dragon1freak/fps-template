extends RayCast3D
class_name Interactor
## The raycast used to interact with things.  Can be disabled

## Emits the state of the interactor.  Can be used to show and hide HUD elements
## for interacting such as pips or button prompts
signal can_interact_changed(can_interact)


## Disables the interactor.  This can be set in code with set_disabled or in the inspector.
@export var disabled := false

## If true, the player can interact with the current target
var can_interact := false


## Returns true if the target exists and has the correct method
func check_can_interact(target) -> bool:
	if target != null and target.has_method("interact"):
		return true
	return false


## Sets the local can_interact variable and emits the can_interact_changed signal
func set_can_interact(value : bool) -> void:
	if value and not can_interact:
		can_interact = true
		can_interact_changed.emit(true)
	if not value and can_interact:
		can_interact = false
		can_interact_changed.emit(false)


func _physics_process(delta):
	if disabled or (not can_interact and not self.is_colliding()):
		return
	
	var interactee = self.get_collider()
	
	if not can_interact and self.is_colliding() and check_can_interact(interactee):
		set_can_interact(true)
	elif can_interact and (not self.is_colliding() or not check_can_interact(interactee)):
		set_can_interact(false)
	
	if Input.is_action_just_pressed("interact") and can_interact:
		interactee.interact()


func set_disabled(value : bool) -> void:
	disabled = value
