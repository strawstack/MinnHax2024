extends Node2D

@export var gc: Node
var tagLookup = {}
var canvasLayerNode

# Loaded by startEvent
var index
var steps

func _ready():
	canvasLayerNode = gc.getCanvasLayer()
	var hiddenLookup = {"afterIce2": true, "overByLeo": true, "atTheWindow": true}
	for child in get_children():
		if not (child.name in hiddenLookup):
			var hashCell = gc.hashCell(gc.worldToCell(child.get_global_position()))
			tagLookup[hashCell] = child

func showTag(tagName):
	var node = get_node(tagName)
	var hashCell = gc.hashCell(gc.worldToCell(node.get_global_position()))
	tagLookup[hashCell] = node
	node.set_visible(true)

func callStartEvent(pathName):
	var jsonString = readFile(pathName)
	var data = parseJSON(jsonString)
	startEvent(data.data)

func removeEvent(hashCell, eventNode):
	tagLookup.erase(hashCell)
	eventNode.set_visible(false)

func triggerEvent(cell):
	var hashCell = gc.hashCell(cell)
	if hashCell in tagLookup:
		gc.setState(func(s): s["event"] = true)
		var eventNode = tagLookup[hashCell]
		var eventName = eventNode.name
		var pathName = "res://events/" + eventName + "/data.json"
		removeEvent(hashCell, eventNode)
		callStartEvent(pathName)

func readFile(pathName):
	var file = FileAccess.open(pathName, FileAccess.READ)
	var content = file.get_as_text()
	return content

func parseJSON(jsonString):
	var json = JSON.new()
	var error = json.parse(jsonString)
	if error == OK: 
		return json.data
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())

func startEvent(data):
	index = 0
	steps = data 
	nextStep()

func nextStep():
	if index >= steps.size():
		# Event complete!
		gc.setState(func(s): s["event"] = false)
	else:
		var step = steps[index]
		index += 1
		if step["type"] == "text":
			handleText(step["name"], step["value"])
			
		elif step["type"] == "achievement":
			handleAchievement(step["name"], step["value"])
			
		elif step["type"] == "function":
			
			if step["name"] == "switch":
				handleSwitch(step["value"])
				
			elif step["name"] == "showBlumpo":
				gc.getEventArtNode().get_node("blumpo").set_visible(true)
				stepComplete()
				
			elif step["name"] == "camera_rotate":
				gc.cameraRotate(step["value"])
				stepComplete()
				
			elif step["name"] == "camera":
				gc.moveCamera(step["value"]["to"], step["value"]["speed"], stepComplete)
				
			elif step["name"] == "zoom":
				gc.zoomCamera(step["value"]["to"], step["value"]["speed"], stepComplete)
				
			elif step["name"] == "camera_track":
				gc.cameraTrack(step["value"])
				stepComplete()
				
			elif step["name"] == "pause":
				gc.pause(step["value"], stepComplete)
				
			elif step["name"] == "seperate":
				gc.seperate(step["value"], stepComplete)
				
			elif step["name"] == "move":
				gc.move(step["value"]["name"], step["value"]["points"], stepComplete)
				
			elif step["name"] == "showTag":
				showTag(step["value"])
				stepComplete()
			
			elif step["name"] == "dimLight":
				gc.dimLight(stepComplete)
			
			elif step["name"] == "raiseLight":
				gc.raiseLight(stepComplete)
				
			elif step["name"] == "start":
				gc.backToStart(step["value"])
			
			elif step["name"] == "dimToBlack":
				gc.dimToBlack(step["value"], stepComplete)
			
			elif step["name"] == "fireOn":
				gc.fireOn()
				stepComplete()

			elif step["name"] == "fireOff":
				gc.fireOff()
				stepComplete()
			
			elif step["name"] == "hillBlock":
				gc.hillBlock(step["value"])
				stepComplete()
			
			else:
				print("Warning: ", step["type"], ": ", step["name"])
				stepComplete()
		else:
			print("Warning: ", step["type"])
			stepComplete()

func handleText(charName, value):
	canvasLayerNode.showText(charName, value, stepComplete)

func handleAchievement(achName, value):
	canvasLayerNode.showAchievement(achName, value)
	stepComplete()

func handleSwitch(charName):
	gc.setState(func(s): s["active_char"] = charName)
	stepComplete()

func stepComplete():
	nextStep()

func _process(_delta):
	pass
