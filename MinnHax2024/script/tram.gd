extends Node3D

@export var tram_start_point: Node3D
@export var tram_end_point: Node3D

@export var door_left: Node3D
@export var door_right: Node3D
@export var door_left_open_pos: Node3D
@export var door_right_open_pos: Node3D

var gc

func _ready():
	gc = get_tree().get_root().get_node("main")
	place_tram_at_start()

func place_tram_at_start():
	set_position(tram_start_point.get_position())

func tramStops():
	gc.exitTram()
	var tween = get_tree().create_tween()
	tween.tween_property(door_left, "position", door_left_open_pos.get_position(), 1).set_trans(Tween.TRANS_SINE)
	tween.set_parallel()
	tween.tween_property(door_right, "position", door_right_open_pos.get_position(), 1).set_trans(Tween.TRANS_SINE)

func start_tram():
	gc.boardTram()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", tram_end_point.get_position(), 5).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(tramStops)

func _process(delta):
	pass
