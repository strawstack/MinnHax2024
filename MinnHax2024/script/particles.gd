extends Node3D

var index = 0
var particles: Array[GPUParticles3D]

func _ready():
	for p in get_children():
		particles.append(p)

func getEmitter():
	var e = particles[index]
	index = (index + 1) % particles.size()
	return e

func fire(globalPoint):
	var p = getEmitter()
	p.set_emitting(false)
	p.restart()
	p.set_position(globalPoint)
	p.set_emitting(true)

func _process(delta):
	pass
