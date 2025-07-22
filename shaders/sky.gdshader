shader_type spatial;
render_mode unshaded, cull_front;

uniform float star_threshold: hint_range(0.0, 1.0, 0.1) = 0.3;

void fragment() {
	// Default space color
	ALBEDO = vec3(0.0, 0.0, 0.01);
}