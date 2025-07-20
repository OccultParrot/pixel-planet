@tool
extends Node3D

func regenerate_shader():
	print("Hello")

@export_tool_button("Regenerate", "Callable") var regenerate_shader_action = regenerate_shader

@export_category("Planet Noise")
@export var landmass_noise: FastNoiseLite
@export var rainfall_noise: FastNoiseLite
@export var temperature_noise: FastNoiseLite
@export_range(0.0, 1.0) var temperature_noise_impact: float = 0.5
@export_range(0.0, 1.0) var displacement_coefficient: float = 0.5

@export_category("Oceans")
@export var landmass_threshold: float = 0.5
@export var beach_width: float = 0.017
@export var shore_width: float = 0.028
@export var ocean_width: float = 0.13

@export_category("Colors")
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

@export_category("DEBUG")
@export var show_temp = false
@export var show_rainfall = false
@export var show_altitude = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if (event as InputEventKey).keycode == KEY_ESCAPE:
			get_tree().quit(0)
