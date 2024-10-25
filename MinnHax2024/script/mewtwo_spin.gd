extends Node3D

@export var back: Node3D
@export var front: Node3D
@export var cube: MeshInstance3D

func _ready():
	var backPos = back.get_position()
	backPos.y = 1
	var frontPos = front.get_position()
	frontPos.y = 1
	
	var tween = get_tree().create_tween()
	tween.tween_property(cube, "position", frontPos, 4)
	tween.tween_property(cube, "position", backPos, 4)
	tween.set_loops()
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(cube, "rotation", Vector3(0, 2 * PI, 0), 4)
	tween2.tween_property(cube, "rotation", Vector3(0, 0, 0), 4)
	tween2.set_loops()

func _process(delta):
	pass
