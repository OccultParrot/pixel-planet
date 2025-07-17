shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D noise;
uniform int pixel_size = 600;
uniform float cloud_threshold = 0.7;
uniform float time_scale: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	float sample = texture(noise, floor((UV - TIME * time_scale / 10.0) * float(pixel_size)) / float(pixel_size)).r;
	ALPHA = sample > cloud_threshold ? 1.0 : 0.0;
	ALBEDO = vec3(1);
}
