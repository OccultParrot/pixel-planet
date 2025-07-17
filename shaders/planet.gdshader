shader_type spatial;
render_mode unshaded;

uniform int pixel_size = 600;

group_uniforms Noise;
uniform sampler2D noise;
uniform float displacement_strength: hint_range(0.0, 2.0) = 0.5;

group_uniforms Mountains;
uniform float mountain_threshold: hint_range(0.0, 1.0) = 0.8;
uniform vec3 mountain_color: source_color = vec3(0.749, 0.749, 0.749);
group_uniforms;

group_uniforms Forests;
uniform float forest_threshold: hint_range(0.0, 1.0) = 0.55;
uniform vec3 forest_color: source_color = vec3(0.3647, 0.7490, 0.2784);
group_uniforms;

group_uniforms Grasslands;
uniform float grassland_threshold: hint_range(0.0, 1.0) = 0.5;
uniform vec3 grassland_color: source_color = vec3(0.5059, 0.9804, 0.4);
group_uniforms;

group_uniforms Beaches;
uniform float beach_threshold: hint_range(0.0, 1.0) = 0.48;
uniform vec3 beach_color: source_color = vec3(1.0, 1.0, 0.749);
group_uniforms;

group_uniforms shores;
uniform float shore_threshold: hint_range(0.0, 1.0) = 0.43;
uniform vec3 shore_color: source_color = vec3(0.2, 0.7059, 1.0);
group_uniforms;

group_uniforms oceans;
uniform vec3 ocean_color: source_color = vec3(0.1098, 0.4588, 0.7882);
group_uniforms;

vec3 determine_color(float sample){
	if (sample > mountain_threshold) {
		return mountain_color;
	} else if (sample > forest_threshold) {
		return forest_color;
	} else if (sample > grassland_threshold) {
		return grassland_color;
	} else if (sample > beach_threshold) {
		return beach_color;
	} else if (sample > shore_threshold){
		return shore_color;
	} else {
		return ocean_color;
	}
}

void vertex() {
	// UNCOMMENT TO MAKE BUMPY
	//vec4 sample = texture(noise, UV);
	//float displacement = sample.r * displacement_strength;
	//VERTEX += NORMAL * displacement;
}

void fragment() {
	float sample = texture(noise, floor(UV * float(pixel_size)) / float(pixel_size)).r;
	ALBEDO = determine_color(sample);
}