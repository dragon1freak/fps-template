extends CharacterBody3D
class_name BaseEnemy

@export var stat_block : EnemyStatBlock
@export var weapon_config : WeaponConfig

# Self properties
@onready var health := stat_block.base_health
@onready var movement_speed := stat_block.base_speed
@onready var jump_strength := stat_block.base_jump_strength
@onready var gravity_force := stat_block.base_gravity

# Get the player and other relevant nodes
@onready var player : PlayerClass = get_tree().get_first_node_in_group("player")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var current_target : Node3D

@export var destroyed := true
var enemy_cost := 0

var can_attack := true
var attacking := false
var can_attack_timer : SceneTreeTimer
var reload_timer : SceneTreeTimer


func _ready() -> void:
	# Can change this later to a find target function or something
	current_target = player


var tick_timer := 1.0
func _process(delta) -> void:
	tick_timer += delta
	if tick_timer >= 1.0:
		_tick()
		tick_timer = 0.0

var final_velocity := Vector3.ZERO
func _physics_process(delta) -> void:
	move_and_slide()
	
	if destroyed:
		velocity = velocity.move_toward(Vector3.ZERO, 0.15)
		return
	
	_handle_movement(delta)
	_handle_gravity(delta)
	_handle_attack(delta)
	
	velocity = final_velocity


var acceleration := 0.0
# override for movement
func _handle_movement(_delta: float) -> void:
	if current_target and global_position.distance_to(current_target.global_position) > weapon_config.max_range:
		transform = interpolated_look_at(transform,  Vector3(player.position.x, 0.0, player.position.z), 0.3)
		final_velocity = transform.basis.z * movement_speed
	else:
		final_velocity = Vector3.ZERO


func _handle_gravity(delta: float) -> void:
	if is_on_floor():
		final_velocity.y = 0
	else:
		final_velocity.y -= gravity_force * delta


# override for attacking, very simple "attack every RoF" method
func _handle_attack(delta: float) -> void:
	if can_attack:
		_attack(delta)


func _attack(_delta) -> void:
	_set_attack_timer(weapon_config.fire_rate)


# override for taking damage
func _damage(damage_amount: int, _damage_type: String = "") -> void:
	health -= damage_amount
	if health <= 0:
		_destroy()


# override for handling death
func _destroy() -> void:
	if not destroyed:
		destroyed = true
		set_collision_layer_value(6, false)
		set_collision_mask_value(6, false)
		if animation_player and animation_player.has_animation("death"):
			animation_player.stop()
			animation_player.clear_queue()
			animation_player.play("death")
			#Audio.play(stat_block.death_sound)
			#EventBus.enemy_killed.emit(self)
			await animation_player.animation_finished
			queue_free()
		else:
			#Audio.play(stat_block.death_sound)
			#EventBus.enemy_killed.emit(self)
			queue_free()


# May want to split this out into a set_can_attack thing so the timers dont stack
func _set_attack_timer(time: float):
	if not is_inside_tree():
		return
	
	can_attack = false
	var tree = get_tree()
	if tree != null:
		can_attack_timer = tree.create_timer(time)
		can_attack_timer.timeout.connect(_set_can_attack)
		return can_attack_timer


func _set_can_attack(value : bool = true) -> void:
	can_attack = value


func _set_attacking(is_attacking : bool = false) -> void:
	attacking = is_attacking


func _tick() -> void:
	pass


# Helper functions for enemies
static func interpolated_look_at(from: Transform3D, to: Vector3, weight: float) -> Transform3D:
	var xform := from
	xform = xform.looking_at(to, Vector3.UP, true)
	return from.interpolate_with(xform, weight)
