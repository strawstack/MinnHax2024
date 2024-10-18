extends Node

var debug = false

func _ready():
	pass

func _process(_delta):
	pass

func _on_button_pressed():
	if debug:
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		$CanvasModulate.fade(func(): get_tree().change_scene_to_file("res://main.tscn"))
		$fire/stones_wood_coals.set_visible(true)
		$fire/flames.set_visible(true)
		$fire/flames.play("fire")
		$fire/PointLight2D.set_visible(true)
		$fire/PointLight2D.startTweenMenu()

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://more_info.tscn")
