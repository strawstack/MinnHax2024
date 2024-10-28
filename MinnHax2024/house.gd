extends Node3D

var doorOpen = 93.5
var doorClose = 86.5

func _ready():
	set_visible(false)

func appear():
	set_visible(true)
	$GPUParticles3D.set_emitting(true)
	
func vanish():
	set_visible(false)
	
func open():
	var tween = get_tree().create_tween()
	var pos = get_position()
	pos.y = doorOpen
	tween.tween_property($door, "position", pos, 1)

func close():
	var tween = get_tree().create_tween()
	var pos = get_position()
	pos.y = doorClose
	tween.tween_property($door, "position", pos, 1)
