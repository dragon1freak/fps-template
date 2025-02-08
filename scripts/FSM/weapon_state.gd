extends State
class_name WeaponState


var current_weapon : WeaponConfig


func enter(t) -> void:
	super(t)
	current_weapon = t.current_weapon
