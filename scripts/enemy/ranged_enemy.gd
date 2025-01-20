extends BaseEnemy
class_name RangedEnemy

@export_range(0.0, 100) var range_buffer := 0.0  # buffer so ranged enemies still shoot when youre out of range if needed
@export var projectile_spawn : Marker3D
@export var projectile_speed := 10.0
@export var projectile_color : Color = Color("8800b5")
@export var projectile_gravity := 1.5
@export var projectile_homing := 0.0
@export var projectile_lifetime := 1.0


var SHOOT_SOUND : AudioStreamPlayer3D
func _ready() -> void:
	super()
	if weapon_config.sound_shoot:
		SHOOT_SOUND = AudioStreamPlayer3D.new()
		self.add_child(SHOOT_SOUND)
		SHOOT_SOUND.stream = weapon_config.sound_shoot
		SHOOT_SOUND.bus = "SFX"
		SHOOT_SOUND.volume_db = -6
		SHOOT_SOUND.unit_size = 15


func _handle_movement(_delta: float) -> void:
	if current_target:
		transform = interpolated_look_at(transform,  Vector3(player.position.x, 0.0, player.position.z), 0.3)
		if global_position.distance_to(current_target.global_position) > weapon_config.max_range:
			final_velocity = transform.basis.z * movement_speed
			if not animation_player.get_queue().has("run") and animation_player.has_animation("run"):
				animation_player.queue("run")
		else:
			final_velocity = Vector3.ZERO


func _handle_attack(delta) -> void:
	if can_attack and player and self.global_position.distance_to(player.global_position) <= weapon_config.max_range + range_buffer:
		_attack(delta)


func _attack(_delta) -> void:
	if weapon_config.max_magazine_size > 0:
		weapon_config.current_magazine -= 1
		if weapon_config.current_magazine <= 0:
			_reload()
	if not can_attack_timer or can_attack_timer.time_left <= 0:
		_set_attack_timer(weapon_config.fire_rate)

	animation_player.play("attack")


func _reload() -> void:
	_set_attack_timer(weapon_config.reload_time)
	await can_attack_timer.timeout
	weapon_config.current_magazine = weapon_config.max_magazine_size


func fire() -> void:
	if SHOOT_SOUND:
		SHOOT_SOUND.play()
	for i in weapon_config.shot_count:
		var new_projectile = weapon_config.projectile.instantiate()
		get_parent().add_child(new_projectile)
		
		var direction = projectile_spawn.global_position.direction_to(player.global_position + Vector3(0, 0.5, 0)).normalized()
		direction = direction.rotated(Vector3.UP, deg_to_rad(weapon_config.spread) * (1 if i % 2 == 0 else -1) * (2 * floor((i + 2.0) / 2.0)))
		new_projectile.global_position = projectile_spawn.global_position
		new_projectile.set_color(projectile_color)
		new_projectile.setup(direction, projectile_speed, projectile_gravity, projectile_lifetime)
		new_projectile.is_active = true
		new_projectile.homing_amount = projectile_homing
