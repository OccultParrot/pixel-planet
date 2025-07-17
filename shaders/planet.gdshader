shader_type spatial;
render_mode unshaded;

uniform int pixel_size = 600;

group_uniforms Noise;
uniform sampler2D noise;
uniform float displacement_strength: hint_range(0.0, 2.0) = 0.5;

group_uniforms Colors;
uniform float mountain_threshold: hint_range(0.0, 1.0) = 0.8;
uniform float forest_threshold: hint_range(0.0, 1.0) = 0.55;
uniform vec3 forest_color: source_color = vec3(93, 191, 71);
uniform float grassland_threshold: hint_range(0.0, 1.0) = 0.5;
uniform float beach_threshold: hint_range(0.0, 1.0) = 0.48;
uniform float shore_threshold: hint_range(0.0, 1.0) = 0.43;

vec3 determine_color(float sample){
	if (sample > mountain_threshold) {
		return vec3(191, 191, 191) / vec3(255);
	} else if (sample > forest_threshold) {
		return vec3(93, 191, 71) / vec3(255);
	} else if (sample > grassland_threshold) {
		return vec3(129, 250, 102) / vec3(255);
	} else if (sample > beach_threshold) {
		return vec3(255, 255, 191) / vec3(255);
	} else if (sample > shore_threshold){
		return vec3(51, 180, 255) / vec3(255);
	} else {
		return vec3(28, 117, 201) / vec3(255);
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

//void light(){
	//
//}