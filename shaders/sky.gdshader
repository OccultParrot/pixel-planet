shader_type sky;

// TODO: Make a procedurally generated space thingy
void sky() {
	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
	COLOR = vec3(0.05);
}
