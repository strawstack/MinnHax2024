extends Node3D

@export var back: Node3D
@export var front: Node3D
@export var stage: MeshInstance3D
@export var poll: MeshInstance3D

func _ready():
	var backPos = back.get_position()
	backPos.y = 1
	var frontPos = front.get_position()
	frontPos.y = 1
	
	var tween = get_tree().create_tween()
	tween.tween_property(stage, "position", frontPos, 4)
	tween.tween_property(stage, "position", backPos, 4)
	tween.set_loops()
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(stage, "rotation", Vector3(0, 2 * PI, 0), 4)
	tween2.tween_property(stage, "rotation", Vector3(0, 0, 0), 4)
	tween2.set_loops()
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property(poll, "rotation", Vector3(0, 2 * PI, 0), 4)
	tween3.tween_property(poll, "rotation", Vector3(0, 0, 0), 4)
	tween3.set_loops()

func _process(delta):
	pass
