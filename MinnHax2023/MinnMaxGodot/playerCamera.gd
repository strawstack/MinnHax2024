extends Camera2D

var gc
var trackPlayer = true
var shouldRotate = false

var leoNode
var benNode

var tween

func _ready():
	gc = get_tree().root.get_node("main")
	leoNode = gc.getLeoNode()
	benNode = gc.getBenNode()

func cameraTrack(value):
	trackPlayer = value 

func rotateCamera(value):
	if value:
		set_ignore_rotation(false)
		shouldRotate = true
		var pos = get_global_position()
		tween = create_tween()
		tween.tween_property(self, "position", pos + Vector2(32, 64), 0.5)
		tween.tween_property(self, "position", pos, 0.5)
		tween.set_loops()
	else:
		tween.stop()
		shouldRotate = false
		set_rotation(0)
		set_ignore_rotation(true)

func moveCameraComplete(pos, callback):
	set_global_position(pos)
	callback.call()

func moveCamera(pos, speed, callback):
	var lTween = create_tween()
	lTween.tween_property(self, "position", pos, speed)
	lTween.tween_callback(func(): moveCameraComplete(pos, callback))

func zoomCameraComplete(value, callback):
	set_zoom(Vector2(1, 1) * value)
	callback.call()

func zoomCamera(value, speed, callback):
	var lTween = create_tween()
	lTween.tween_property(self, "zoom", Vector2(1, 1) * value, speed)
	lTween.tween_callback(func(): zoomCameraComplete(value, callback))

func _process(delta):
	var state = gc.getState()

	if shouldRotate:
		rotation += delta * 1

	if trackPlayer:
		if state["active_char"] == "ben":
			set_global_position(benNode.get_global_position())
		else:
			set_global_position(leoNode.get_global_position())
