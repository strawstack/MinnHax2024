extends Node3D

var vec = Vector3(0.023, 0, 0.017)
var isDone = false

func _ready():
	pass

func done():
	isDone = true

func _process(delta):
	if not isDone:
		var rot = get_rotation()
		set_rotation(rot + vec)
