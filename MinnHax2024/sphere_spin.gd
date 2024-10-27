extends Node3D

var vec = Vector3(0.023, 0, 0.017)

func _ready():
	pass

func _process(delta):
	var rot = get_rotation()
	set_rotation(rot + vec)
