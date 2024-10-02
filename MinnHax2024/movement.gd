extends CharacterBody3D

var speed = 0.25
var shiftSpeed = 0.4

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

func _process(delta):
	var dir = get_directions()
	var velocity = Vector3()
	for d in ["forward", "right", "back", "left"]:
		if Input.is_action_pressed(d):
			velocity += dir[d]
	
	if Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	move_and_collide(velocity.normalized() * (shiftSpeed if Input.is_action_pressed("run") else speed))
