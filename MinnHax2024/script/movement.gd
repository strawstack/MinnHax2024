extends CharacterBody3D

var speed = 5
var shiftSpeed = 10

func _ready():
	pass

var mouse_sens = 0.3
var camera_anglev = 0

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if event is InputEventMouseMotion:
		self.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		var changev =- event.relative.y * mouse_sens
		if camera_anglev + changev > -50 and camera_anglev + changev < 50:
			camera_anglev += changev
			$Camera3D.rotate_x(deg_to_rad(changev))

func get_directions():
	var base = self.get_global_transform().basis
	return {
		"forward": -base.z,
		"back": base.z,
		"left": -base.x,
		"right": base.x
	}

func sync_photo_camera():
	var rotY = get_rotation().y
	$SubViewport/photo_camera.set_rotation(Vector3(0, rotY, 0))
	var global_pos = to_global($photo_camera_placeholder.get_position())
	$SubViewport/photo_camera.set_position(global_pos)

func _process(delta):
	var dir = get_directions()
	var vel = Vector3()
	for d in ["forward", "right", "back", "left"]:
		if Input.is_action_pressed(d):
			vel += dir[d]
	
	if Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	velocity = vel.normalized() * (shiftSpeed if Input.is_action_pressed("run") else speed)
	move_and_slide()
	
	sync_photo_camera()

var push_force = 10.0
func _physics_process(delta):
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
