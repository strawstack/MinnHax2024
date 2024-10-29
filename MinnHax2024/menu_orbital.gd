extends Node

var once = true

func _ready():
	pass

func _process(delta):
	pass

func _on_start_pressed():
	if once:
		once = false
		var tween = get_tree().create_tween()
		tween.tween_property($CanvasModulate, "color", Color.BLACK, 1)
		await tween.finished
		get_tree().change_scene_to_file("res://main2.tscn")
