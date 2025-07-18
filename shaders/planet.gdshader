shader_type spatial;
render_mode unshaded;

uniform int pixel_size = 600;

group_uniforms Noise;
uniform sampler2D noise;
uniform float displacement_coefficient: hint_range(0.0, 1.0) = 0.5;

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

group_uniforms latitude;
uniform float pole_threshold: hint_range(0.0, 1.0) = 0.35;
group_uniforms;

// Linear Interpolation Function.
float lerp(float a, float b, float t) {
	return a + (b - a) * t;
}

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
	float sample = texture(noise, UV).r;
	if (sample < grassland_threshold) {
		sample = beach_threshold;
	}
	
	VERTEX = NORMAL * lerp(beach_threshold, sample, displacement_coefficient / 10.0);
}

void fragment() {
	// The UV is a range from 0.0 -> 1.0, so 0.5 is the equator.
	float dist_from_equator = distance(0.5, UV.y);
	
	// The floor(UV * pixel_size) / pixel_size is how we make it pixelated. 
	// It has some weird artifacts we need to fix at large pixel sizes though... To do with the fact its a sphere I think
	float sample = texture(noise, floor(UV * float(pixel_size)) / float(pixel_size)).r;
	
	vec3 point_color =  determine_color(sample);
	
	if (dist_from_equator > pole_threshold) {
		point_color = min(point_color + vec3(0.1), vec3(1.0));
	}
	
	ALBEDO = point_color;
}