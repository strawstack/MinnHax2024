extends Node2D

@export var gc: Node
var tagsNode
@export var charName: String = ""

var slip = false
var facing = 2 # 0: up, 1: right, 2: down, 3: left
var facingLookup

var facingRequest = null
var moveRequest = null

func _ready():
	var curCell = currentCell()
	tagsNode = gc.getTagsNode()
	gc.setState(func(s): s[charName]["cell"] = curCell)
	gc.reportReady(charName)
	facingLookup = [
		Vector2(0, -1),
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(-1, 0)
	]
	
func movingFalse():
	var state = gc.getState()
	var curCell = currentCell()
	
	if state["active_char"] == charName:
		tagsNode.triggerEvent(curCell)
		slip = gc.isIce(curCell)
	
	if slip:
		var fd = facingLookup[facing]
		move(curCell + fd)
	else:
		gc.setState(func(s): s[charName]["moving"] = false)
		maybeMove()

func move(targetCell):
	gc.setState(func(s): s[charName]["moving"] = true)
	gc.setState(func(s): s[charName]["cell"] = targetCell)
	var curCell = currentCell()
	
	# Announce movement
	var state = gc.getState()
	if (not state["seperate"]) and state["active_char"] == charName:
		otherCharNode().listenForMovement(curCell, facing)
	
	var tween = create_tween()
	var worldTarget = gc.cellToWorld(targetCell)
	tween.tween_property(self, "position", worldTarget, 0.216) 
	tween.tween_callback(movingFalse)
	
func listenForMovement(targetCell, leaderFacing):
	facing = leaderFacing
	move(targetCell)

func currentCell():
	return gc.worldToCell(get_global_position())

func otherCharName():
	return "leo" if charName == "ben" else "ben"

func otherCharNode():
	return get_tree().root.get_node("main" + "/" + otherCharName())

func checkKeys(charState):
	facingRequest = null
	moveRequest = null

	if Input.is_action_pressed("up"):
		facingRequest = 0
		moveRequest = charState["cell"] + Vector2(0, -1)
		
	elif Input.is_action_pressed("right"):
		facingRequest = 1
		moveRequest = charState["cell"] + Vector2(1, 0)

	elif Input.is_action_pressed("down"):
		facingRequest = 2
		moveRequest = charState["cell"] + Vector2(0, 1)

	elif Input.is_action_pressed("left"):
		facingRequest = 3
		moveRequest = charState["cell"] + Vector2(-1, 0)

func maybeMove():
	var state = gc.getState()
	var charState = state[charName]
	var curCell = currentCell()
	
	if (not charState["moving"]) and (not state["event"]):
	
		if facingRequest != null:
			facing = facingRequest
	
		if moveRequest != null and gc.inBounds(moveRequest) and (not curCell.is_equal_approx(moveRequest)):
			move(moveRequest)

func setMovementAnimation():
	var isMoving = gc.getState()[charName]["moving"]
	var aSprite = $AnimatedSprite2D
	aSprite.set_flip_h(false)
	if facing == 0:
		if isMoving and not slip:
			aSprite.play("up")
		else:
			aSprite.play("idle_up")

	elif facing == 1:
		if isMoving and not slip:
			aSprite.play("right")
		else:
			aSprite.play("idle_right")

	elif facing == 2:
		if isMoving and not slip:
			aSprite.play("down")
		else:
			aSprite.play("idle_down")

	elif facing == 3:
		aSprite.set_flip_h(true)
		if isMoving and not slip:
			aSprite.play("right")
		else:
			aSprite.play("idle_right")

func _process(_delta):

	var state = gc.getState()
	var charState = state[charName]
	
	setMovementAnimation()
	
	if state["ready"]:
		if state["active_char"] == charName: # and not state[otherCharName()]["moving"]
			checkKeys(charState)
			maybeMove()
		else:
			facingRequest = null
			moveRequest = null
