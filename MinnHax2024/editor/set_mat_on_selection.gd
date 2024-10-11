@tool
extends EditorScript

var shader: Resource

func _run():
	shader = load(get_editor_interface().get_current_path())
	
	for obj in EditorPlugin.new().get_editor_interface().get_selection().get_selected_nodes():
		var sm = ShaderMaterial.new()
		sm.set_shader(shader)
		obj.mesh.surface_set_material(0, sm)
