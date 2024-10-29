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

func fire(globalPoint, isTarget):
	var p = getEmitter()
	var mat = p.get_draw_pass_mesh(0).surface_get_material(0)
	var color = Color("d86800") #orange
	if not isTarget:
		color = Color("ffffff")
	mat.set_albedo(color)
	mat.set_emission(color)
	p.set_emitting(false)
	p.restart()
	p.set_position(globalPoint)
	p.set_emitting(true)

func _process(delta):
	pass
