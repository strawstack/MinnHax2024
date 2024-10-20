extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func startTweenMenu():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "energy", 0.5, 2)
	tween.tween_property(self, "energy", 0, 1).set_delay(1)

func startTweenGame():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "energy", 0.5, 1)
