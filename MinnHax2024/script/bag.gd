extends Node3D

@export var spotLight3D: SpotLight3D

var bagUp = 0.9
var bagDown = 0

func _ready():
	$SpotLight3D.set_visible(false)

func lightOn():
	$SpotLight3D.set_visible(true)

func lightOff():
	$SpotLight3D.set_visible(false)

func lift():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", bagUp, 1)
	tween.tween_callback(lightOn)
	
func down():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", bagDown, 1)
	tween.tween_callback(lightOff)

func _process(delta):
	pass
