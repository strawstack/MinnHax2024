extends Node3D

@export var tram_start_point: Node3D
@export var tram_end_point: Node3D

var gc

func _ready():
	gc = get_tree().get_root().get_node("main")
	place_tram_at_start()

func place_tram_at_start():
	set_position(tram_start_point.get_position())

func start_tram():
	gc.boardTram()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", tram_end_point.get_position(), 10).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(gc.exitTram)

func _process(delta):
	pass
