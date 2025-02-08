extends Area3D
## Used to check the player's interaction action


@onready var count_label: Label3D = $Count


## Called when interacted with, simply increments the label on the mesh up by one
func interact() -> void:
	count_label.text = str(float(count_label.text) + 1)
