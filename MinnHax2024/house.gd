extends Node3D

var doorOpen = 93.5
var doorClose = 86.5

@export var particles: GPUParticles3D

func _ready():
	set_visible(false)

func appear():
	set_visible(true)
	particles.set_emitting(true)
	
func vanish():
	set_visible(false)
	particles.set_emitting(false)
	particles.restart()
	particles.set_emitting(true)
	
func open():
	var tween = get_tree().create_tween()
	var pos = $door.get_position()
	pos.y = doorOpen
	tween.tween_property($door, "position", pos, 1)

func close():
	var tween = get_tree().create_tween()
	var pos = $door.get_position()
	pos.y = doorClose
	tween.tween_property($door, "position", pos, 1)
