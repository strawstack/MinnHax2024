extends Node3D

@export var laser: CSGMesh3D
@export var orby: Node3D

var physics_check = false
var laserTime = 0.025 # Laser shows for this time on shoot
var laserTimer = 0

var gc
func _ready():
	gc = get_tree().get_root().get_node("main")
	laser.set_visible(false)

func shoot_callback(result):
	if result != null:
		var dist = (result.position - $start_point.get_global_position()).length()
		laserLength(dist)
		gc.particles.fire(result.position)
		if result.collider.name == "orby_hit_zone":
			orby.takeDamage()
	else:
		laserLength(100)

func shoot():
	laserTimer = laserTime
	physics_check = true

func laserLength(value):
	var v2 = value/2
	var scale = laser.get_scale()
	scale.y = v2
	laser.set_scale(scale)
	var pos = laser.get_position()
	pos.z = -1 * v2
	laser.set_position(pos)

func _process(delta):
	if laserTimer > 0:
		laser.set_visible(true)
		laserTimer -= delta
	else:
		laser.set_visible(false)

func _physics_process(delta):
	if physics_check:
		physics_check = false
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create($start_point.get_global_position(), $end_point.get_global_position(), 0b01000000)
		var result = space_state.intersect_ray(query)
		if result:
			shoot_callback(result)
		else:
			shoot_callback(null)
