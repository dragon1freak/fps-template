extends CanvasLayer
class_name PlayerHud

# We could also get the player with `owner` or other path based approaches, but this makes it easier to pull
# this code out into other scenes if needed.
@onready var player : PlayerClass = get_tree().get_first_node_in_group("player")

@onready var ammo_counter: Label = %AmmoCounter


func _process(delta: float) -> void:
	if player and player.current_weapon:
		ammo_counter.text = str(player.current_weapon.current_magazine)
