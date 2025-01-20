extends RayCast3D
## The raycast used to interact with things.  Can be disabled 

signal can_interact_changed(can_interact)


var can_interact := false
var disabled := false


func check_can_interact(target) -> bool:
	if target != null and target.has_method("interact"):
		return true
	return false


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
