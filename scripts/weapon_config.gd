extends Resource
class_name WeaponConfig
## Config resource for weapon data.  Holds everything needed for the weapon to be displayed and function.

@export var states : WeaponStateConfig 

@export_subgroup("Model")
@export var model: PackedScene  # Model of the weapon
@export var position: Vector3  # On-screen position
@export var rotation: Vector3  # On-screen rotation
@export var muzzle_flash: PackedScene # The scene used for the muzzle flash
@export var muzzle_position: Vector3  # On-screen position of muzzle flash
@export var muzzle_scale: Vector3 = Vector3(1, 1, 1)  # Scale of the muzzle flash

@export_subgroup("Properties")
@export var automatic := false # Is the weapon a single fire or fully automatic
@export_range(0.1, 1) var fire_rate: float = 0.1  # Firerate
@export_range(1, 100) var max_magazine_size : int = 8 : 
	set(value):
		current_magazine = value
		max_magazine_size = value
@export_range(0.25, 4, 0.01) var reload_time := 0.5
@export_range(1, 50) var max_range: int = 100  # Fire distance
@export_range(0, 100) var damage: float = 25  # Damage per hit
@export_range(0, 30) var spread: float = 0  # Spread of each shot

## The following properties are a bit more bespoke, you may not need these
@export_range(1, 10) var shot_count: int = 1  # Amount of shots per shot, increase for shotguns etc
@export_range(0.0, 5.0, 0.1) var kick: float = 0.2  # Amount of kick the weapon has, can affect player knockback etc

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
@export var impact: PackedScene # Impact scene


## The weapon's current magazine
var current_magazine = 8
