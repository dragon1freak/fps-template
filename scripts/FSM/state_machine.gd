extends Node
class_name StateMachine

@export var state_target : Node
@export var initial_state : State

var states : Dictionary = {}
var current_state : State


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter(state_target)
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.update(delta)


func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)


func _input(event):
	if current_state:
		current_state.input_update(event)


func on_child_transition(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	
	var new_state : State = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter(state_target)
	current_state = new_state
