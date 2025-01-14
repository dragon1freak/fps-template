extends RayCast3D


var colliding := false


func can_interact(target) -> bool:
	var interactee = self.get_collider()
	if interactee != null and interactee.has_method("interact"):
		return true
	else:
		interactee = interactee.get_parent()
		if interactee != null and interactee.has_method("interact"):
			return true
	return false


func _physics_process(delta):
	if not colliding and self.is_colliding():
		colliding = true
		#if can_interact(self.get_collider()):
			#PlayerHud.toggle_pip_visibility(true)
	elif colliding and not self.is_colliding():
		colliding = false
		#PlayerHud.toggle_pip_visibility(false)
	elif colliding and self.is_colliding():
		if not can_interact(self.get_collider()):
			colliding = false
			#PlayerHud.toggle_pip_visibility(false)
		else:		
			colliding = true
			#if can_interact(self.get_collider()):
				#PlayerHud.toggle_pip_visibility(true)
		
	if Input.is_action_just_pressed("interact"):
		var interactee = self.get_collider()
		if interactee != null:
			if interactee.has_method("interact"):
				interactee.interact()
			else:
				interactee = interactee.get_parent()
				if interactee != null and interactee.has_method("interact"):
					interactee.interact()
