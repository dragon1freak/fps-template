extends Resource
class_name WeaponConfig

@export_subgroup("Model")
@export var model: PackedScene  # Model of the weapon
@export var position: Vector3  # On-screen position
@export var rotation: Vector3  # On-screen rotation
@export var muzzle_position: Vector3  # On-screen position of muzzle flash
@export var muzzle_scale: Vector3 = Vector3(1, 1, 1)  # On-screen position of muzzle flash

@export_subgroup("Properties")
@export var automatic := false
@export_range(0.1, 1) var fire_rate: float = 0.1  # Firerate
@export_range(1, 100) var max_magazine_size : int = 8 : 
	set(value):
		current_magazine = value
		max_magazine_size = value
@export_range(0.25, 4, 0.01) var reload_time := 0.5
@export_range(1, 50) var max_range: int = 100  # Fire distance
@export_range(0, 100) var damage: float = 25  # Damage per hit
@export_range(0, 30) var spread: float = 0  # Spread of each shot
@export_range(1, 10) var shot_count: int = 1  # Amount of shots
@export_range(0, 50) var knockback: int = 20  # Amount of knockback
@export_range(0.0, 5.0, 0.1) var kick: float = 0.2  # Amount of kick on the model

@export_subgroup("Sounds", "sound_")
@export var sound_shoot: AudioStream
@export var sound_post_shoot : AudioStream
@export var sound_reload_start : AudioStream
@export var sound_reload_step : AudioStream
@export var sound_reload_end : AudioStream

@export_subgroup("Crosshair")
@export var crosshair: Texture2D  # Image of crosshair on-screen

@export_subgroup("Projectile")
@export var projectile: PackedScene # The projectile scene
@export var impact: PackedScene = null # Impact scene


var current_magazine = 8

#
#func reload(entity : Node3D) -> void:
	#if stepped_reload:
		#if reload_start_sound:
			#Audio.play(reload_start_sound)
		#await _stepped_reload(entity)
		#if reload_end_sound:
			#Audio.play(reload_end_sound)
	#else:
		#if reload_sound:
			#Audio.play(reload_sound)
			#await entity.get_tree().create_timer(reload_time - 0.25).timeout
		#elif reload_start_sound:
			#Audio.play(reload_start_sound)
			#await entity.get_tree().create_timer(reload_time / 2.0).timeout
			#Audio.play(reload_step_sound)
			#await entity.get_tree().create_timer((reload_time / 2.0)).timeout
			#Audio.play(reload_end_sound)
		#else:
			#await entity.get_tree().create_timer(reload_time - 0.25).timeout
	#current_magazine = max_magazine_size
#
#
#func _stepped_reload(entity : Node3D) -> void:
	#await entity.get_tree().create_timer(reload_time / 2.0).timeout
	#if reload_step_sound:
		#Audio.play(reload_step_sound)
	#await entity.get_tree().create_timer(reload_time / 2.0).timeout
	#current_magazine += 1
	#if current_magazine < max_magazine_size:
		#if entity == null:
			#return
		#await _stepped_reload(entity)
