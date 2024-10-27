extends Node3D

@export var start: Node3D
@export var points: Array[Node3D]

var isDone = false
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()

func go():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", start.get_position(), 1)
	await tween.finished
	$Timer.start()

func done():
	$Timer.stop()

func _on_timer_timeout():
	var tween = get_tree().create_tween()
	var r = randi() % 4
	tween.tween_property(self, "position", points[r].get_position(), 1)
