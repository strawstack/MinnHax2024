extends Node3D

@export var orbyPoints: Node3D

var oneSecPer = 2.0
var isTrackingPlayer = false
var player

var SMOOTH_SPEED = 10

var gc
func _ready():
	gc = get_tree().get_root().get_node("main")
	player = gc.getPlayer()

func moveTo(target):
	var tween = get_tree().create_tween()
	var distance = (target - get_position()).length()
	tween.tween_property(self, "position", target, distance / oneSecPer)
	await tween.finished

func moveToName(pointName):
	var target = orbyPoints.get_node(pointName).get_position()
	await moveTo(target)

func lookAt(target):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", target, 0.8).set_trans(Tween.TRANS_SINE)
	await tween.finished

func lookAtAndMoveTo(target):
	await lookAt(target)
	await moveTo(target)

func trackPlayer(state):
	isTrackingPlayer = state

func _process(delta):
	if isTrackingPlayer:
		var op = get_position() # Orby position
		var pp = player.get_position() # Player pos
		var d = (Vector2(pp.x, pp.z) - Vector2(op.x, op.z)).length() # Horizontal dist orby to player
		var h = pp.y - op.y # Vertical distance
		$body.set_rotation(Vector3(lerp_angle($body.rotation.x, atan2(h, d), delta * SMOOTH_SPEED), 0, 0))
		set_rotation(Vector3(0, lerp_angle(rotation.y, atan2(op.x - pp.x, op.z - pp.z), delta * SMOOTH_SPEED), 0))
