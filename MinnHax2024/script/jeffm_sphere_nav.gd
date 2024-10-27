extends Node3D

@export var start: Node3D
@export var points: Array[Node3D]

var isDone = false
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()

func nextPoint():
	var tween = get_tree().create_tween()
	var r = randi() % 4
	var w = (randi() % 3 + 1) / 2
	tween.tween_property(self, "position", points[r].get_position(), 2)
	tween.tween_interval(w)
	await tween.finished
	if not done:
		nextPoint()

func go():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", start.get_position(), 1)
	await tween.finished
	nextPoint()

func done():
	isDone = true

func _process(delta):
	pass
