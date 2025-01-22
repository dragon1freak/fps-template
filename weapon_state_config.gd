extends Resource
class_name WeaponStateConfig


@export var states : Dictionary = {
	"Idle": preload("res://scenes/player/weapon_states/idle.gd"),
	"Shoot": preload("res://scenes/player/weapon_states/shoot.gd"),
	"Reload": preload("res://scenes/player/weapon_states/reload.gd")
}


func get_states() -> Dictionary:
	return states
