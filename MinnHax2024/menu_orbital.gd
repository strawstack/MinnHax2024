extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasModulate, "color", Color.BLACK, 1)
	await tween.finished
	get_tree().change_scene_to_file("res://main2.tscn")
