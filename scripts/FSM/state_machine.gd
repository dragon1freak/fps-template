extends Node
class_name StateMachine

@export var state_target : Node
@export var initial_state : State

var states : Dictionary = {}
var current_state : State


var is_active := true


func _ready():
	register_children()
	
	if initial_state and is_active:
		initial_state.enter(state_target)
		current_state = initial_state

func register_children() -> void:
	states = {}
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)


func _process(delta):
	if is_active and current_state:
		current_state.update(delta)


func _physics_process(delta):
	if is_active and current_state:
		current_state.physics_update(delta)


func _input(event):
	if is_active and current_state:
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


func set_states(new_states : Dictionary) -> void:
	current_state = null
	for n in get_children():
		self.remove_child(n)
		n.queue_free()
	
	for key in new_states:
		var new_state = Node.new()
		new_state.name = key
		new_state.set_script(new_states[key])
		self.add_child(new_state)
	register_children()
	on_child_transition(null, new_states.keys()[0])


func reset_state() -> void:
	if initial_state:
		on_child_transition(current_state, initial_state.name)
	else:
		on_child_transition(current_state, states.keys()[0])
