extends BaseEnemy
class_name MeleeEnemy


@onready var weapon_slot: Node3D = %WeaponSlot
@onready var hurt_box: Area3D = %HurtBox


func _ready() -> void:
	var new_weapon = weapon_config.model.instantiate()
	weapon_slot.add_child(new_weapon)
	super()


func _handle_attack(delta) -> void:
	if can_attack and player and self.global_position.distance_to(player.global_position) <= weapon_config.max_range:
		_attack(delta)


func _attack(_delta: float) -> void:
	attacking = true
	if animation_player.current_animation != "Run":
		animation_player.stop()

	animation_player.play("Attack")
	#if weapon_config.sound_shoot:
		#Audio.play(weapon_config.sound_shoot)
	var new_timer = _set_attack_timer(animation_player.current_animation_length / animation_player.speed_scale)
	if new_timer:
		new_timer.timeout.connect(_set_attacking)


func _handle_movement(delta: float) -> void:
	if not attacking:
		if current_target and global_position.distance_to(current_target.global_position) > weapon_config.max_range:
			animation_player.queue("Run")
		super(delta)


func check_for_hits() -> void:
	for body in hurt_box.get_overlapping_bodies():
		if body.has_method("_damage"):
			body._damage(weapon_config.damage)
