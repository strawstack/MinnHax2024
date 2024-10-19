extends CharacterBody3D

var speed = 5
var shiftSpeed = 10
var mouse_sens = 0.3
var camera_anglev = 0

var isCameraUp = false
var tweenCamera: Tween
var tweenCameraRot: Tween

var photoScene = preload("res://photo.tscn")

var gc
func _ready():
	gc = get_tree().get_root().get_node("main")

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
	var playerY = get_rotation().y
	var cameraX = $Camera3D.get_rotation().x
	$SubViewport/photo_camera.set_rotation(Vector3(cameraX, playerY, 0))
	$SubViewport/photo_camera.set_global_position($Camera3D/camera/photo_camera_placeholder.get_global_position())

func moveCamera(target, tRot):
	if tweenCamera != null:
		tweenCamera.pause()
		tweenCamera.kill()
	if tweenCameraRot != null:
		tweenCameraRot.pause()
		tweenCameraRot.kill()
	tweenCamera = get_tree().create_tween()
	tweenCameraRot = get_tree().create_tween()
	tweenCamera.tween_property($Camera3D/camera, "position", target, 0.5)
	tweenCameraRot.tween_property($Camera3D/camera, "rotation", tRot, 0.5)

func takePhoto():
	var photo = photoScene.instantiate()
	gc.photos.add_child(photo)
	photo.set_position($Camera3D/camera/photo_start.get_global_position())
	var vp = $Camera3D/camera/camera_preview_render.get_texture()
	var texture = ImageTexture.create_from_image(vp.get_image())
	photo.setTexture(texture)
	photo.eject(get_directions()["forward"])

func _process(delta):
	var dir = get_directions()
	var vel = Vector3()
	for d in ["forward", "right", "back", "left"]:
		if Input.is_action_pressed(d):
			vel += dir[d]
	
	if Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Player movement
	velocity = vel.normalized() * (shiftSpeed if Input.is_action_pressed("run") else speed)
	move_and_slide()
	
	# Sync position of sub viewport camera
	sync_photo_camera()
	
	# Camera lift
	if Input.is_action_just_pressed("space"):
		if isCameraUp:
			isCameraUp = false
			moveCamera($camera_down.get_position() - $Camera3D.get_position(), $camera_down.get_rotation())
		else:
			isCameraUp = true
			moveCamera($camera_up.get_position() - $Camera3D.get_position(), $camera_up.get_rotation())
	
	# Take photo
	if Input.is_action_just_pressed("lmb"):
		takePhoto()

var push_force = 10.0
func _physics_process(delta):
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
