extends Resource
class_name WeaponStateConfig
## Config resource for the states used by a weapon.
##
## When swapping weapons, if the WeaponStateConfig doesnt match the previous weapon,
## the weapon states will be removed and replaced with the new WeaponStateConfig, so
## when reusing these, make sure to save the resource instead of just creating new ones
## in the inspector.


## Dictionary of weapon states.  The keys will be used as the state's name.
@export var states : Dictionary = {
	"Idle": preload("res://scenes/player/weapon_states/idle.gd"),
	"Shoot": preload("res://scenes/player/weapon_states/shoot.gd"),
	"Reload": preload("res://scenes/player/weapon_states/reload.gd")
}


func get_states() -> Dictionary:
	return states
