extends CanvasLayer

var CUT_OFF = 160
var achUp = 32
var achDown = 160

@export var gc: Node

# Child nodes set by _ready
var boxLeft
var boxRight
var achievementBox

var boxLeftLabel
var boxRightLabel
var boxLeftAdvance
var boxRightAdvance
var achievementBoxTitle

var leoHead
var benHead

var upTimer

# Set by nextLine
var index
var lines
var lineLength
var currentLine

# Set by showText
var targetLabel
var targetAdvance
var stepComplete
var targetLine
var targetLineCount

# Track key press and current state
var keyPressActive = false
var textAnimating = false

# Text timers
var charSpeed = 0.015
var symbolSpeed = 0.35
var charTimer = 0

var symbolLookup = {
	",": true,
	".": true
}

func _ready():
	boxLeft = get_node("textBoxLeft")
	boxRight = get_node("textBoxRight")
	achievementBox = get_node("achievementBox")
	
	boxLeftLabel = get_node("textBoxLeft/Label")
	boxRightLabel = get_node("textBoxRight/Label")
	achievementBoxTitle = get_node("achievementBox/Label2")
	
	boxLeftAdvance = get_node("textBoxLeft/advance")
	boxRightAdvance = get_node("textBoxRight/advance")

	upTimer = get_node("achievementBox/upTimer")
	
	leoHead = get_node("textBoxLeft/leo")
	benHead = get_node("textBoxLeft/ben")
	
	boxLeft.set_visible(false)
	boxRight.set_visible(false)
	# achievementBox.set_visible(false)

func showLeftBox(value):
	boxLeft.set_visible(value)
	boxRight.set_visible(!value)

func join(array, delimit):
	var i = 0
	var res = ""
	while i < array.size():
		var d = delimit if i < array.size() - 1 else ""
		var word = array[i]
		i += 1
		res += word + d
	return res

func makeLines(value):
	var words = value.split(" ")
	var wi = 0
	var tLines = []
	var line = []
	var count = 0
	while wi < words.size():
		var word = words[wi]
		wi += 1
		if count + word.length() + 3 >= CUT_OFF:
			var follow = ""
			if wi < words.size() - 1:
				follow = "..."
			tLines.append(join(line, " ") + follow)
			line.clear()
			count = 0
		line.append(word)
		count += word.length()
	if line.size() > 0:
		tLines.append(join(line, " "))
	return tLines

func showText(charName, value, _stepComplete):
	stepComplete = _stepComplete
	index = 0
	lines = makeLines(value)
	
	if charName == "leo":
		benHead.set_visible(false)
		leoHead.set_visible(true)

	elif charName == "ben":
		benHead.set_visible(true)
		leoHead.set_visible(false)
	
	if charName == "leo" or charName == "ben":
		targetLabel = boxLeftLabel
		targetAdvance = boxLeftAdvance
		showLeftBox(true)
	elif charName == "janet":
		targetLabel = boxRightLabel
		targetAdvance = boxRightAdvance
		showLeftBox(false)

	nextLine()

func noSpaces(line):
	var res = ""
	for c in line:
		if not (c == " "):
			res += c
	return res

func nextLine():
	if index >= lines.size():
		keyPressActive = false
		boxLeft.set_visible(false)
		boxRight.set_visible(false)
		stepComplete.call()
	else: 
		var line = lines[index]
		targetLine = line
		targetLineCount = line.length()
		index += 1
		targetLabel.set_visible_characters(0)
		targetLabel.set_text(line)
		targetAdvance.set_visible(false)
		keyPressActive = true
		textAnimating = true

func achievementReady(audioClip):
	# Play audio here
	gc.playAudio(audioClip)
	upTimer.start()

func achTweenUp(audioClip):
	var tween = create_tween()
	tween.tween_property(achievementBox, "position", Vector2(0, achUp), 0.5)
	tween.tween_callback(func(): achievementReady(audioClip))

func achTweenDown():
	var tween = create_tween()
	tween.tween_property(achievementBox, "position", Vector2(0, achDown), 0.5)

func showAchievement(achName, audioClip):
	achievementBoxTitle.set_text(achName)
	achTweenUp(audioClip)

func isSymbol(char):
	var lookup = {
		",": true,
		"!": true,
		";": true,
		".": true
	}
	return char in lookup

func _process(delta):
	if textAnimating:
		charTimer -= delta
		if charTimer <= 0:
			var ncv = targetLabel.get_visible_characters() + 1
			if ncv == targetLineCount:
				targetLabel.set_visible_characters(ncv)
				textAnimating = false
				targetAdvance.set_visible(true)
			else:
				if ncv >= 1 and isSymbol(targetLine[ncv - 1]):
					charTimer = symbolSpeed
				else:
					charTimer = charSpeed
				targetLabel.set_visible_characters(ncv)

	if keyPressActive and Input.is_action_just_pressed("action"):
		if textAnimating:
			textAnimating = false
			targetAdvance.set_visible(true)
			targetLabel.set_visible_characters(targetLineCount)
		else:
			nextLine()

func _on_up_timer_timeout():
	achTweenDown()
