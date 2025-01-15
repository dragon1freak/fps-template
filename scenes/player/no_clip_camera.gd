extends Camera3D


@onready var main_camera: Camera3D = %MainCamera


func _physics_process(_delta: float) -> void:
	self.global_transform = main_camera.global_transform
