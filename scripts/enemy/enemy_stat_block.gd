extends Resource
class_name EnemyStatBlock

@export var death_sound : AudioStream = null

@export_group("Base Properties")
@export_range(1, 5000) var base_health: int = 100
@export_range(0.1, 100) var base_speed: float = 5
@export_range(1, 100) var base_jump_strength: int = 13

# TODO I want to move this to a Room or Environment singleton so it affects the whole room on one value
# maybe keep this as a fallback
@export_range(0, 100) var base_gravity: int = 30
