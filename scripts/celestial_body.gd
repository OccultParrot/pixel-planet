@tool
extends Node3D

func refresh_shader():
	print("Refreshing CelestialBody...")
	$Planet.refresh_shader()
	$Clouds.refresh_shader()
	print("Done.")
	
func randomise_noise():
	$Planet.randomise_noise()
	$Clouds.randomise_noise()

@export_tool_button("Refresh Shader", "ShaderMaterial") var refresh_action = refresh_shader
@export_tool_button("Randomise Noise", "NoiseTexture2D") var rand_action = randomise_noise
