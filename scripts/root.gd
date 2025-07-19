extends Node3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if (event as InputEventKey).keycode == KEY_ESCAPE:
			get_tree().quit(0)
