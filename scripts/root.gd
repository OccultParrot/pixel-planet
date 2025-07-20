@tool
extends Node3D
func regenerate_shader():
	var material: ShaderMaterial = $"Celestial Body/Planet".get_active_material(0)

	if material and material.shader:
		# Initalizing Noise
		print("Updating Planet Uniforms...")
		var land_noise_texture = NoiseTexture2D.new()
		land_noise_texture.noise = landmass_noise
		land_noise_texture.seamless = true
		#await land_noise_texture.changed
		
		var rain_noise_texture = NoiseTexture2D.new()
		rain_noise_texture.noise = rainfall_noise
		rain_noise_texture.seamless = true
		#await rain_noise_texture.changed
		
		var temp_noise_texture = NoiseTexture2D.new()
		temp_noise_texture.noise = temperature_noise
		temp_noise_texture.seamless = true
		#await temp_noise_texture.changed
		
		# Update noise parameters
		material.set_shader_parameter("landmass_noise", land_noise_texture)
		material.set_shader_parameter("rainfall_noise", rain_noise_texture)
		material.set_shader_parameter("temperature_noise", temp_noise_texture)
		material.set_shader_parameter("temperature_noise_impact", temperature_noise_impact)
		material.set_shader_parameter("displacement_coefficient", displacement_coefficient)

		# Update ocean parameters
		material.set_shader_parameter("landmass_threshold", landmass_threshold)
		material.set_shader_parameter("beach_width", beach_width)
		material.set_shader_parameter("shore_width", shore_width)
		material.set_shader_parameter("ocean_width", ocean_width)

		# Update color parameters
		material.set_shader_parameter("pixel_size", pixel_size)
		material.set_shader_parameter("beach_color", beach_color)
		material.set_shader_parameter("shore_color", shore_color)
		material.set_shader_parameter("ocean_color", ocean_color)
		material.set_shader_parameter("deep_ocean_color", deep_ocean_color)
		material.set_shader_parameter("dry_color", dry_color)
		material.set_shader_parameter("wet_color", wet_color)
		material.set_shader_parameter("desert_color", desert_color)
		material.set_shader_parameter("cold_color", cold_color)
		material.set_shader_parameter("cold_wet_color", cold_wet_color)

		# Update debug parameters
		material.set_shader_parameter("DEBUG_temp_gradient", show_temp)
		material.set_shader_parameter("DEBUG_rainfall_noise", show_rainfall)
		material.set_shader_parameter("DEBUG_altitude_noise", show_altitude)
		print("Done.")
	else:
		print("Warning: No valid planet shader material found!")
		
	material = $"Celestial Body/Clouds".get_active_material(0)
	
	if material and material.shader:
		print("Updating Cloud Uniforms...")
		
		var cloud_noise_texture = NoiseTexture2D.new()
		cloud_noise_texture.noise = cloud_noise
		cloud_noise_texture.seamless = true
		
		material.set_shader_parameter("noise", cloud_noise_texture)
		material.set_shader_parameter("cloud_threshold", cloud_threshold)
		material.set_shader_parameter("pixel_size", cloud_pixel_size)
		material.set_shader_parameter("cloud_color", cloud_color)
		
		print("Done.")
	else:
		print("Warning: No valid cloud shader material found!")


func randomise_noise():
	print_rich("==== [b]Randomising Noise[/b] ====")
	landmass_noise.seed = randi()
	#await landmass_noise.changed
	print("Landmass Seed:", landmass_noise.seed)

	rainfall_noise.seed = randi()
	#await rainfall_noise.changed
	print("Rainfall Seed:", rainfall_noise.seed)

	temperature_noise.seed = randi()
	#await temperature_noise.changed
	print("Temperature Seed:", temperature_noise.seed)
	
	cloud_noise.seed = randi()
	#await cloud_noise.changed
	print("Cloud Seed:", cloud_noise.seed)

@export_category("Shader Tools & Settings")
@export_tool_button("Regenerate", "Callable") var regenerate_shader_action = regenerate_shader
@export_tool_button("Randomise Noise", "NoiseTexture2D") var randomise_noise_action = randomise_noise

@export_group("DEBUG")
@export var show_temp = false
@export var show_rainfall = false
@export var show_altitude = false

@export_category("Planet")

@export_group("Noise")
@export var landmass_noise: FastNoiseLite
@export var rainfall_noise: FastNoiseLite
@export var temperature_noise: FastNoiseLite
@export_range(0.0, 1.0) var temperature_noise_impact: float = 0.5
@export_range(0.0, 1.0) var displacement_coefficient: float = 0.5

@export_group("Oceans")
@export var landmass_threshold: float = 0.5
@export var beach_width: float = 0.017
@export var shore_width: float = 0.028
@export var ocean_width: float = 0.13

@export_group("Colors")
@export var pixel_size: int = 600
@export var beach_color: Color = Color("d2c9a5")
@export var shore_color: Color = Color("8caba1")
@export var ocean_color: Color = Color("4b726e")
@export var deep_ocean_color: Color = Color("345955")
@export var dry_color: Color = Color("77743b")
@export var wet_color: Color = Color("4d4539")
@export var desert_color: Color = Color("d1b187")
@export var cold_color: Color = Color("6b6535")
@export var cold_wet_color: Color = Color("6b6535")

@export_category("Clouds")
@export var cloud_noise: FastNoiseLite
@export var cloud_threshold: float = 0.7
@export_range(0.0, 10000, 2.0) var cloud_pixel_size: int = 600
@export var cloud_color: Color = Color.WHITE_SMOKE

func unhandledinput(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if (event as InputEventKey).keycode == KEY_ESCAPE:
			get_tree().quit(0)
