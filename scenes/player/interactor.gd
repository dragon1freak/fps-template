extends RayCast3D


signal can_interact_changed(can_interact)


var can_interact := false


func check_can_interact(target) -> bool:
	if target != null and target.has_method("interact"):
		return true
	return false


func _physics_process(delta):
	var interactee = self.get_collider()
	
	#if _is_colliding:
		#if self.is_colliding():
			#_is_colliding = check_can_interact(interactee)
			#can_interact_changed.emit(check_can_interact(interactee))
			#print("is and is")
		#else:
			#_is_colliding = false
			#can_interact_changed.emit(false)	
			#print("is and isnt")
	#elif self.is_colliding():
		#_is_colliding = true
		#print("isnt and is")
		#if check_can_interact(interactee):
			#can_interact_changed.emit(true)
	
	if not can_interact and self.is_colliding():
		print("not and is")
		can_interact = true
		if check_can_interact(interactee):
			can_interact_changed.emit(true)
	elif can_interact and not self.is_colliding():
		print("is and not")
		can_interact = false
		can_interact_changed.emit(false)
	elif can_interact and self.is_colliding():
		if not check_can_interact(interactee):
			print("stop")
			can_interact = false
			can_interact_changed.emit(false)
		else:
			print("show")
			can_interact = true
			if check_can_interact(interactee):
				can_interact_changed.emit(true)
	
	if Input.is_action_just_pressed("interact") and can_interact:
		interactee.interact()
