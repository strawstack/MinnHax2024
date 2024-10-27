extends MeshInstance3D

func _ready():
	pass

func begin_rotate(duration):
	var tween = get_tree().create_tween()
	var rot = get_rotation()
	rot.y = deg_to_rad(-150)
	tween.tween_property(self, "rotation", rot, duration)

func _process(delta):
	pass
