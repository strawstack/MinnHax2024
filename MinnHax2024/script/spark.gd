extends Node3D

@export var orbyPoints: Node3D
@export var battlePoints: Array[Node3D]
@export var healthBarUI: CanvasLayer
@export var healthBar: ProgressBar

@export var knife_stand: Node3D
@export var knife_self: Node3D
@export var knife_ground: Node3D

var speed = 5
var isTrackingPlayer = false
var player

var SMOOTH_SPEED = 1

var current_clip = null
var current_look_target_node = null
var targetingInProgress = false

var isSpeaking = false

var inBattle = false
var batteClips = ["T8", "T9", "T10"]
var battleClipIndex = 0
var health = 100
var hasShield = false

signal look_complete
signal battle_complete

var random = RandomNumberGenerator.new()

var gc
func _ready():
	gc = get_tree().get_root().get_node("main")
	player = gc.getPlayer()
	random.randomize()

func teleportToName(pointName):
	set_position(orbyPoints.get_node(pointName).get_position())

func moveToName(pointName):
	print(pointName)
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
	print(pointName)
	var targetNode = orbyPoints.get_node(pointName)
	await _lookAtAndMoveTo(targetNode)

func _lookAtAndMoveTo(targetNode):
	await _lookAt(targetNode)
	await _moveTo(targetNode)

func say(clipName):
	var audioStream = gc.getAudio(clipName)
	$AudioStreamPlayer3D.set_stream(audioStream)
	current_clip = clipName
	isSpeaking = true
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	isSpeaking = false

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
	var ans = max(aa, bb) - min(aa, bb)
	var special_case = 2 * PI - ans # -PI and +PI but still very close
	return min(ans, special_case)

func battleComplete():
	healthBarUI.set_visible(false)
	speed = 5
	inBattle = false
	$Timer.stop()
	$moveTimer.stop()
	await moveToName("battle5")
	knife_self.set_visible(false)
	knife_ground.set_visible(true)
	await say("T11")
	await say("T12")
	lookAtAndMoveToName("club_heart")
	battle_complete.emit()

func shield():
	hasShield = true
	$shield.set_visible(true)
	$shieldTimer.start()

func takeDamage():
	if not hasShield:
		health -= 5
		healthBar.set_value(health)
		if health <= 0:
			battleComplete()
		if health % 20 == 0:
			shield()

func knifeBattle():
	knife_stand.set_visible(false)
	knife_self.set_visible(true)
	healthBarUI.set_visible(true)
	speed = 20
	inBattle = true
	$Timer.start()
	$moveTimer.start()
	lookAtName("player")

func _process(delta):
	var op = get_position() # Orby position
	var pp = getPositionOrDefault(current_look_target_node, get_position() + Vector3.DOWN)
	var d = (Vector2(pp.x, pp.z) - Vector2(op.x, op.z)).length()
	var h = pp.y - op.y
	var xa = atan2(h, d) # x axis angle
	var ya = atan2(op.x - pp.x, op.z - pp.z) # y axis angle
	$body.set_rotation(Vector3(lerp_angle($body.rotation.x, xa, delta * SMOOTH_SPEED), 0, 0))
	set_rotation(Vector3(0, lerp_angle(rotation.y, ya, delta * SMOOTH_SPEED), 0))
	
	var small = 0.1
	var dya = angleDiff(rotation.y, ya)
	if dya < small and targetingInProgress:
		targetingInProgress = false
		look_complete.emit()

func _on_timer_timeout():
	if inBattle:
		var clipName = batteClips[battleClipIndex]
		battleClipIndex = (battleClipIndex + 1) % batteClips.size()
		say(clipName)

func _on_shield_timer_timeout():
	hasShield = false
	$shield.set_visible(false)

func _on_move_timer_timeout():
	var r = randi() % battlePoints.size()
	var pName = battlePoints[r].name
	moveToName(NodePath(pName))
