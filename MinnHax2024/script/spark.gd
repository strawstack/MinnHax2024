extends Node3D

@export var orbyPoints: Node3D

var oneSecPer = 2.0
var isTrackingPlayer = false
var player

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
		look_at(player.get_position())
