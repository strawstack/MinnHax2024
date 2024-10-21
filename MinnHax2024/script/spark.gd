extends Node3D

@export var orbyPoints: Node3D

var speed = 5
var isTrackingPlayer = false
var player

var SMOOTH_SPEED = 1

var current_clip = null
var current_look_target_node = null
var targetingInProgress = false

signal look_complete

var gc
func _ready():
	gc = get_tree().get_root().get_node("main")
	player = gc.getPlayer()

func moveToName(pointName):
	var targetNode = orbyPoints.get_node(pointName)
	await _moveTo(targetNode)

func _moveTo(targetNode):
	var tween = get_tree().create_tween()
	var distance = (targetNode.get_position() - get_position()).length()
	var pos = targetNode.get_position()
	tween.tween_property(self, "position", pos, distance * 1/speed)
	await tween.finished

func _getName(pName):
	return orbyPoints.get_node(pName)

func lookAtName(pointName):
	var targetNode = getPlayerNodeOrDefault(pointName, _getName)
	await _lookAt(targetNode)

func _lookAt(targetNode):
	targetingInProgress = true
	current_look_target_node = targetNode
	await look_complete

func lookAtAndMoveToName(pointName):
	var targetNode = orbyPoints.get_node(pointName)
	await _lookAtAndMoveTo(targetNode)

func _lookAtAndMoveTo(targetNode):
	await _lookAt(targetNode)
	await _moveTo(targetNode)

func say(clipName):
	var audioStream = gc.getAudio(clipName)
	$AudioStreamPlayer3D.set_stream(audioStream)
	current_clip = clipName
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished

func getPlayerNodeOrDefault(nodeName, defaultFunc):
	if nodeName == "player":
		return player
	else:
		return _getName(nodeName)

func getPositionOrDefault(node, default):
	if node == null:
		return default
	else:
		return node.get_position()

func angleDiff(a, b):
	var aa = atan2(sin(a), cos(a))
	var bb = atan2(sin(b), cos(b))
	return max(aa, bb) - min(aa, bb)

func _process(delta):
	var op = get_position() # Orby position
	var pp = getPositionOrDefault(current_look_target_node, get_position() + Vector3.DOWN)
	var d = (Vector2(pp.x, pp.z) - Vector2(op.x, op.z)).length()
	var h = pp.y - op.y
	var xa = atan2(h, d) # x axis angle
	var ya = atan2(op.x - pp.x, op.z - pp.z) # y axis angle
	$body.set_rotation(Vector3(lerp_angle($body.rotation.x, xa, delta * SMOOTH_SPEED), 0, 0))
	set_rotation(Vector3(0, lerp_angle(rotation.y, ya, delta * SMOOTH_SPEED), 0))
	
	var small = 0.05
	var dya = angleDiff(rotation.y, ya)
	if dya < small and targetingInProgress:
		targetingInProgress = false
		look_complete.emit()
