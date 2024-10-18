extends CanvasModulate

func fade(callback):
	var tween = create_tween()
	tween.tween_property(self, "color", Color.BLACK, 2)
	tween.tween_callback(callback).set_delay(2)
