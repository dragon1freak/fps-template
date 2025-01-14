extends Node
class_name State


signal transitioned


# called when entering the state
func enter(_state_target: Node) -> void:
	pass


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
