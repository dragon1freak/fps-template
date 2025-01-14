extends Resource
class_name StatBlock

# Max stat values
@export var health := 10

@export var speed := 10

@export var stamina := 10

@export var mana := 10

@export var health_regen := 0 # Points per second

@export var stamina_regen := 1.0 # Points per second

@export var mana_regen := 1.0 # Points per second

@export var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var jump_strength : float = 5.0
