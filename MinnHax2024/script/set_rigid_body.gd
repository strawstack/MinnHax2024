@tool
extends EditorScript

func _run():
	var root = get_editor_interface().get_edited_scene_root()
	for obj in EditorPlugin.new().get_editor_interface().get_selection().get_selected_nodes():
		
		print(obj.name)
		
		var rb = RigidBody3D.new()
		var cs = CollisionShape3D.new()

		obj.add_child(rb, true)
		rb.owner = root
		rb.add_child(cs, true)
		cs.owner = root
		
		var box = BoxShape3D.new()
		box.set_size(Vector3(9, 2, 3))
		cs.set_shape(box)
