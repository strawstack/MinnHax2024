@tool
extends EditorScript

func _run():
	var root = get_editor_interface().get_edited_scene_root()
	for obj in EditorPlugin.new().get_editor_interface().get_selection().get_selected_nodes():
		
		obj.get_node("RigidBody3D").set_collision_layer_value(1, false)
		obj.get_node("RigidBody3D").set_collision_layer_value(2, false)
		obj.get_node("RigidBody3D").set_collision_layer_value(3, true)
		
		obj.get_node("RigidBody3D").set_collision_mask_value(1, true)
		obj.get_node("RigidBody3D").set_collision_mask_value(2, true)
		obj.get_node("RigidBody3D").set_collision_mask_value(3, true)
