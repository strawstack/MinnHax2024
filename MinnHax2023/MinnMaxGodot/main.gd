extends Node

@export var leoNode: Node2D
@export var benNode: Node2D
@export var tagsNode: Node2D
@export var canvasLayerNode: CanvasLayer
@export var canvasModulate: CanvasModulate
@export var eventAssetsNode: Node2D

var debug = false

var readyLookup = {
	"leo": false,
	"ben": false,
	"light": false
}

var state = {
	"ready": false,
	"event": false, # eventInProgress
	"active_char": "ben",
	"seperate": false,
	"leo": {
		"cell": Vector2(0, 0),
		"moving": false,
	},
	"ben": {
		"cell": Vector2(0, 0),
		"moving": false,
	}
}

var pauseTimerCallback # set by pause function from json

func fadeInComplete():
	setState(func(s): s["event"] = true)
	reportReady("light")
	var pathName = "res://events/start/data.json"
	tagsNode.callStartEvent(pathName)

func _ready():
	if debug:
		reportReady("light")
	else:
		canvasModulate.setBlack()
		canvasModulate.fadeIn(fadeInComplete)

	# Force correct visibility
	$CanvasLayer.set_visible(true)
	$tags.set_visible(true)
	$bounds.set_visible(false)
	for item in $eventAssets.get_children():
		item.set_visible(false)
	$eventAssets/fire.set_visible(true)
	$eventAssets/house_over_water.set_visible(true)
	
	# Add temp bounds to bounds
	setChildrenBoundsAndVisible($eventAssets/hillBottomBlock, true)
	setChildrenBoundsAndVisible($eventAssets/hillSideBlock, true)
	setChildrenBoundsAndVisible($eventAssets/logBlock, true)

func reportReady(key):
	readyLookup[key] = true
	for k in readyLookup:
		if not readyLookup[k]:
			return
	setState(func(s): s["ready"] = true)

func cellToWorld(cellVec):
	return cellVec * 32.0

func worldToCell(worldVec):
	return Vector2(floor(worldVec.x / 32.0), floor(worldVec.y / 32.0))

func hashCell(cell):
	return str(cell.x) + ":" + str(cell.y)

func getTagsNode():
	return tagsNode

func getCanvasLayer():
	return canvasLayerNode

func getEventArtNode():
	return eventAssetsNode

func getState():
	return state

func getLeoNode():
	return leoNode

func getBenNode():
	return benNode

func setState(userFunction):
	userFunction.call(getState())

func isIce(cell):
	return $ice.isIce(cell)

func inBounds(cell):
	return not $bounds.inBounds(cell)

func addBound(cell):
	$bounds.addBounds(cell)

func removeBound(cell):
	$bounds.addBounds(cell)

func playAudio(audioClip):
	$audioStreams.get_node(audioClip).play()

func cameraRotate(value):
	$Camera2D.rotateCamera(value)

func moveCamera(to, speed, callback):
	var pos
	if to == "ben":
		pos = benNode.get_global_position()
	elif to == "leo":
		pos = leoNode.get_global_position()
	else:
		pos = $eventAssets.get_node(to).get_global_position()
	$Camera2D.moveCamera(pos, speed, callback)

func zoomCamera(to, speed, callback):
	$Camera2D.zoomCamera(to, speed, callback)

func cameraTrack(value):
	$Camera2D.cameraTrack(value)

func pause(value, callback):
	$pauseTimer.set_wait_time(value)
	pauseTimerCallback = callback
	$pauseTimer.start()

func seperate(value, callback):
	setState(func(s): s["seperate"] = value)
	callback.call()

func calcDiffTime(prev, target):
	return (target - prev).length() / 32 * 0.2

func charMoveComplete(charName, pos, callback):
	var charNode = leoNode if charName == "leo" else benNode
	charNode.facing = 2
	var cell = worldToCell(pos)
	setState(func(s): s[charName]["cell"] = cell)
	setState(func(s): s[charName]["moving"] = false)
	callback.call()

func setFacing(charNode, prev, next):
	if is_equal_approx(next.x, prev.x):
		if next.y > prev.y:
			charNode.facing = 2
		else:
			charNode.facing = 0
	else:
		if next.x > prev.x:
			charNode.facing = 1
		else:
			charNode.facing = 3

func move(charName, points, callback):
	setState(func(s): s[charName]["moving"] = true)
	var charNode = leoNode if charName == "leo" else benNode
	var tween = create_tween()
	var prevPos = charNode.get_global_position()
	for point in points:
		var targetPos = worldToCell($eventAssets.get_node(point).get_global_position()) * 32.0
		tween.tween_method(func(x): setFacing(charNode, prevPos, targetPos), Vector2.ZERO, Vector2.ZERO, 0)
		tween.tween_property(charNode, "position", targetPos, calcDiffTime(prevPos, targetPos))
		prevPos = targetPos
	tween.tween_callback(func(): charMoveComplete(charName, prevPos, callback))

func dimLight(callback):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color(0.4, 0.4, 0.4), 2)
	tween.tween_callback(callback)

func raiseLight(callback):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color.WHITE, 2)
	tween.tween_callback(callback)

func dimToBlack(value, callback):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color.BLACK, value)
	tween.tween_callback(callback)

func backToStartComplete():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func backToStart(value):
	$pauseTimer.set_wait_time(value)
	pauseTimerCallback = backToStartComplete
	$pauseTimer.start()

func fireOn():
	$eventAssets/fire.turnOn()

func fireOff():
	$eventAssets/fire.turnOff()

func setChildrenBoundsAndVisible(node, value):
	node.set_visible(value)
	for child in node.get_children():
		var pos = child.get_global_position()
		var cell = worldToCell(pos)
		if value:
			$bounds.addBound(cell)
		else:
			$bounds.removeBound(cell)

func hillBlock(value):
	if value == 1:
		setChildrenBoundsAndVisible($eventAssets/hillBottomBlock, false)
		setChildrenBoundsAndVisible($eventAssets/hillSideBlock, true)
		setChildrenBoundsAndVisible($eventAssets/logBlock, true)

	elif value == 2:
		setChildrenBoundsAndVisible($eventAssets/hillBottomBlock, true)
		setChildrenBoundsAndVisible($eventAssets/hillSideBlock, false)
		setChildrenBoundsAndVisible($eventAssets/logBlock, true)

	elif value == 3:
		setChildrenBoundsAndVisible($eventAssets/hillBottomBlock, true)
		setChildrenBoundsAndVisible($eventAssets/hillSideBlock, true)
		setChildrenBoundsAndVisible($eventAssets/logBlock, false)

func _on_pause_timer_timeout():
	var temp = pauseTimerCallback
	pauseTimerCallback = null
	temp.call()

func _on_wind_forest_crows_finished():
	$audioStreams/wind_forest_crows.play()
