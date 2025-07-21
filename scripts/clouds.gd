@tool
extends MeshInstance3D

func randomise_noise():
	cloud_noise.seed = randi()
	#await cloud_noise.changed
	print("Cloud Seed:", cloud_noise.seed)

func refresh_shader():
	print("Refreshing Clouds...")
	var material = get_active_material(0)
	if material and material.shader:
		var cloud_noise_texture = NoiseTexture2D.new()
		cloud_noise_texture.noise = cloud_noise
		cloud_noise_texture.seamless = true
		
		material.set_shader_parameter("noise", cloud_noise_texture)
		material.set_shader_parameter("cloud_threshold", cloud_threshold)
		material.set_shader_parameter("pixel_size", cloud_pixel_size)
		material.set_shader_parameter("cloud_color", cloud_color)
		print("Done.")
	else:
		print("Clouds is missing importatant feature(s).")

@export_tool_button("Refresh Shader", "ShaderMaterial") var refresh_action = refresh_shader
@export_tool_button("Randomise Noise", "NoiseTexture2D") var rand_action = randomise_noise

@export var cloud_noise: FastNoiseLite
@export var cloud_threshold: float = 0.7
@export_range(0.0, 10000, 2.0) var cloud_pixel_size: int = 600
@export var cloud_color: Color = Color.WHITE_SMOKE

@export_range(0, 100) var rotation_speed: float = 2

func _physics_process(delta: float) -> void:
	rotate(Vector3(0, 1, 0).normalized(), rotation_speed / 1000)
