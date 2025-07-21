@tool
extends Node3D
func refresh_shader():
	print("=== Refeshing All Shaders ===")
	$"CelestialBody".refresh_shader()
	$Skybox.refresh_shader()
	
func randomise_noise():
	$CelestialBody.randomise_noise()
	$Skybox.randomise_noise()
	
@export_tool_button("Refresh Shader", "ShaderMaterial") var refresh_action = refresh_shader
@export_tool_button("Randomise Noise", "NoiseTexture2D") var rand_action = randomise_noise

func unhandledinput(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if (event as InputEventKey).keycode == KEY_ESCAPE:
			get_tree().quit(0)
