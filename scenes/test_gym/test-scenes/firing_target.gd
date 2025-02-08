extends StaticBody3D


@onready var damage_label: Label3D = $DamageLabel


var cooldown_timer : SceneTreeTimer


func _ready() -> void:
	hide_label()


func _damage(amount) -> void:
	damage_label.visible = true
	damage_label.text = str(amount + int(damage_label.text))
	if cooldown_timer:
		cooldown_timer.timeout.disconnect(hide_label)
		cooldown_timer = null
	cooldown_timer = get_tree().create_timer(3.0)
	cooldown_timer.timeout.connect(hide_label)


func hide_label() -> void:
	damage_label.visible = false
	damage_label.text = "0"
