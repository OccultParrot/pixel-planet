shader_type spatial;
render_mode unshaded;

uniform int pixel_size: hint_range(0, 1000000, 2) = 600;

group_uniforms Noise;
uniform sampler2D landmass_noise;
uniform sampler2D rainfall_noise;
uniform sampler2D temperature_noise;
uniform float temperature_noise_impact: hint_range(0.0, 1.0) = 0.5;
uniform float displacement_coefficient: hint_range(0.0, 1.0) = 0.5;
group_uniforms;

group_uniforms Landmass;
uniform float landmass_threshold: hint_range(0.0, 1.0) = 0.5;
uniform float beach_width: hint_range(0.0, 0.05) = 0.017;
uniform float shore_width: hint_range(0.0, 0.05) = 0.028;
uniform float ocean_width: hint_range(0.0, 0.5) = 0.13;
group_uniforms;

group_uniforms Colors;
uniform vec3 beach_color: source_color = vec3(1.0, 1.0, 0.749);
uniform vec3 shore_color: source_color = vec3(0.2, 0.7059, 1.0);
uniform vec3 ocean_color: source_color = vec3(0.1098, 0.4588, 0.7882);
uniform vec3 deep_ocean_color: source_color = vec3(0);
uniform vec3 temperate_color: source_color = vec3(0);
uniform vec3 tundra_color: source_color = vec3(1);
uniform vec3 cold_color: source_color = vec3(0);
uniform vec3 desert_color: source_color = vec3(0.5);
uniform vec3 dry_color: source_color = vec3(0.0);

group_uniforms Debug;
uniform bool DEBUG_temp_gradient = false;
uniform bool DEBUG_rainfall_noise = false;
uniform bool DEBUG_altitude_noise = false;

// Linear Interpolation Function.
float lerp(float a, float b, float t) {
	return a + (b - a) * t;
}

vec2 pixelate(vec2 pos, float scale) {
	return (floor(pos * scale) + 0.5) / scale;
}

int zone(float value, int num_zones) {
	return int(clamp(value * float(num_zones), 0.0, float(num_zones - 1)));
}

vec4 sample(sampler2D source, vec2 pos) {
	return texture(source, pixelate(pos, float(pixel_size)));
}

vec3 determine_color(float altitude, float rainfall, float temperature) {
	// === Ocean and beaches ===
	if (altitude < landmass_threshold - shore_width - ocean_width) return deep_ocean_color;
	if (altitude < landmass_threshold - shore_width) return ocean_color;
	if (altitude < landmass_threshold) return shore_color;
	if (altitude < landmass_threshold + beach_width) return beach_color;

	int rainfall_zone = zone(rainfall, 4);
	int temperature_zone = 4 - zone(temperature, 4);

	if (temperature_zone < 2 && rainfall_zone < 2) return tundra_color;
	if (temperature_zone < 2 && rainfall_zone >= 2) return cold_color;
	if (temperature_zone >= 2 && rainfall_zone >= 2) return temperate_color;
	if (temperature_zone == 4 && rainfall_zone < 1) return desert_color;
	if (temperature_zone >= 2 && rainfall_zone < 2) return dry_color;



	return vec3(1.0, 0, 0);
}

//void vertex() {
	//float sample = texture(landmass_noise, UV).r;
	//if (sample < landmass_threshold) {
		//sample = landmass_threshold;
	//}
	//
	//VERTEX = NORMAL * lerp(landmass_threshold, sample, displacement_coefficient / 10.0);
//}

void fragment() {
	float altitude = sample(landmass_noise, UV).r;
	float rainfall = sample(rainfall_noise, UV).r;
	// The UV is a range from 0.0 -> 1.0, so 0.5 is the equator.
	// By scaling it by 2 we made it a range from 0.0 -> 0.5 into a range from 0.0 -> 1.0
	float temperature = distance(0.5, UV.y) * 2.0;

	// Our temperature is a hard gradient from 0 at the center to 1 at the top and bottom.
	// To help break up the hard lines, we add a layer of noise on top (Clamped to 0 and 1).
	temperature = clamp(temperature + sample(temperature_noise, UV).r * temperature_noise_impact, 0.0, 1.0);

	ALBEDO = determine_color(altitude, rainfall, temperature);

	// DEBUG DISPLAY
	if (DEBUG_temp_gradient) ALBEDO = vec3(temperature);
	if (DEBUG_rainfall_noise) ALBEDO = vec3(rainfall);
	if (DEBUG_altitude_noise) ALBEDO = vec3(altitude);
}