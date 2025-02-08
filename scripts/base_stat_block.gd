extends Resource
class_name BaseStatBlock
## Max stat values


@export var health := 10

@export_group("Movement")
@export var speed := 8

@export var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var jump_strength : float = 8.0
