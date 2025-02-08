extends CPUParticles3D
# Simple script to emit the impart particles and delete it.
# You can edit this particle effect or use your own impact scene, 
# this is just an example

func _ready() -> void:
	emitting = true
	await self.finished
	queue_free()
