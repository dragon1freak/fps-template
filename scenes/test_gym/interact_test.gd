extends Area3D

@onready var count_label: Label3D = $Count

func interact() -> void:
	count_label.text = str(float(count_label.text) + 1)
