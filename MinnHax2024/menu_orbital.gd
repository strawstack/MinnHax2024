extends Node

var once = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_pressed():
	if once:
		once = false
		var tween = get_tree().create_tween()
		tween.tween_property($CanvasModulate, "color", Color.BLACK, 1)
		await tween.finished
		get_tree().change_scene_to_file("res://base.tscn")
