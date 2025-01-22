extends State
class_name NPCState


@export var state_target : Node


var player: CharacterBody3D


func enter(new_target: Node) -> void: 
	if new_target is CharacterBody3D:
		target = new_target if new_target else state_target
	
	if !player:
		player = get_tree().get_first_node_in_group("player")
