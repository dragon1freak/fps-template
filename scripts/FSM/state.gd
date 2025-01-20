extends Node
class_name State


var target : Node


signal transitioned


# called when entering the state
func enter(state_target: Node) -> void:
	target = state_target


# called when exiting the state
func exit():
	pass


# equivilent to the _process function
func update(_delta: float):
	pass


# equivilent to the _physics_process function
func physics_update(_delta: float):
	pass


func input_update(_event) -> void:
	pass


func transition(target_state : String) -> void:
	self.transitioned.emit(self, target_state)
