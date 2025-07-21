shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D noise;
uniform int pixel_size = 600;
uniform float cloud_threshold = 0.7;
uniform vec3 cloud_color: source_color = vec3(1.0);

vec2 pixelate(vec2 p, float s) {
	return (floor(p * s) + 0.5) / s;
}

void fragment() {
	float sample = texture(noise, pixelate(UV, float(pixel_size))).r;
	ALPHA = sample > cloud_threshold ? 1.0 : 0.0;
	ALBEDO = cloud_color;
}
