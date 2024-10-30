extends Node3D

func _ready():
	delayLoadMain()

func delayLoadMain():
	await get_tree().create_timer(0.5).timeout
	var scene = preload("res://main2.tscn").instantiate()
	get_tree().root.add_child(scene)

func hideLoading():
	$CanvasLayer.set_visible(false)
