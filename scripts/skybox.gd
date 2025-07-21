@tool
extends MeshInstance3D

func refresh_shader():
	print("Refreshing Skybox Shader...")
	var material: ShaderMaterial = get_active_material(0)
	if material and material.shader and mesh:
		var mesh_reference: SphereMesh = mesh
		material.set_shader_parameter("radius", mesh_reference.radius)
		
		print("Done.")
	else:
		print("Skybox is missing importatant feature(s).")
	
func randomise_noise():
	pass
	
@export_tool_button("Refresh Shader", "ShaderMaterial") var refresh_action = refresh_shader
@export_tool_button("Randomise Noise", "NoiseTexture2D") var rand_action = randomise_noise
