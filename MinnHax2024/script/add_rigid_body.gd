@tool
extends EditorScript

func _run():
	var root = get_editor_interface().get_edited_scene_root()
	for obj in EditorPlugin.new().get_editor_interface().get_selection().get_selected_nodes():
		var tower = obj.get_parent()
		var rb = RigidBody3D.new()
		tower.add_child(rb, true)
		rb.owner = root
		
		obj.reparent(rb)
