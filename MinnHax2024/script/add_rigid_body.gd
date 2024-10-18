@tool
extends EditorScript

func _run():
	var root = get_editor_interface().get_edited_scene_root()
	for obj in EditorPlugin.new().get_editor_interface().get_selection().get_selected_nodes():
		var tower = obj.get_parent()
		var rb = RigidBody3D.new()

		# Add RB to tower
		tower.add_child(rb, true)
		rb.owner = root

		var pos = obj.get_position()

		var isEven = (int(floor((pos.y - 1) / 2)) % 2) == 0

		rb.set_position(pos)

		# Remove cube as child and add to RB
		tower.remove_child(obj)
		rb.add_child(obj, true)
		obj.owner = root

		obj.set_position(Vector3.ZERO)

		# Create CS and add as child of RB
		var cs = CollisionShape3D.new()
		rb.add_child(cs, true)
		cs.owner = root

		# Add shape to CS
		var box = BoxShape3D.new()
		if isEven:
			box.set_size(Vector3(3, 2, 9))
		else:
			box.set_size(Vector3(9, 2, 3))
		cs.set_shape(box)
