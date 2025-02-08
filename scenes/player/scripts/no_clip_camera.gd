extends Camera3D
## Moves the weapon camera to the transform of the real camera so the environment lighting is correct


@onready var main_camera: Camera3D = %MainCamera


func _physics_process(_delta: float) -> void:
	self.global_transform = main_camera.global_transform
