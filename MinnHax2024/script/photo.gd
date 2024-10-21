extends RigidBody3D

var force = 8

func _ready():
	pass

func setTexture(texture):
	$camera_preview_render.set_texture(texture)

func eject(forward):
	apply_central_impulse(forward * force)

func _process(delta):
	pass
