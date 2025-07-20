#@tool
extends MeshInstance3D

@export_range(0, 100) var rotation_speed: float = 2

func _physics_process(delta: float) -> void:
	rotate(Vector3(0, 1, 0).normalized(), rotation_speed / 1000)
