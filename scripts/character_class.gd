extends CharacterBody3D
class_name BaseCharacterClass

@export var stat_block : StatBlock

@onready var current_stats : StatBlock = stat_block.duplicate() if stat_block else null


func _physics_process(delta):
	if current_stats == null:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= current_stats.gravity * delta
	
	move_and_slide()
 
