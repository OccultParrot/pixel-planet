shader_type spatial;
render_mode cull_front, unshaded;
uniform float radius = 250.0;
uniform sampler3D nebula_noise;
uniform float pixel_size = 600;
uniform float nebula_threshold: hint_range(0.0, 1.0, 0.1) = 0.8;

varying vec3 world_position;
varying vec3 local_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    local_position = VERTEX;
}

vec3 pixelate(vec3 p, float s) {
	vec3 grid_pos = floor(p * s);
	return grid_pos / s;
}

float sample_3d(sampler3D noise, vec3 p, float s) {
	return texture(noise, pixelate(p, s)).r;
}

void fragment() {
	vec3 uv_3d = (local_position / radius + 1.0) * 0.5;
	
	// Set the default space color
	ALBEDO = vec3(0.0, 0.0, 0.01);
	
	float sample = sample_3d(nebula_noise, uv_3d, pixel_size);
	
	ALBEDO += (sample > nebula_threshold) ? vec3(0.5) : vec3(0.0);
}