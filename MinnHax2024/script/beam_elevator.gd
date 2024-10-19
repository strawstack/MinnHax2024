extends Node3D


var gc
func _ready():
	gc = get_tree().get_root().get_node("main")

func up():
	var player = gc.get_player()
	# barriers up
	# reparent player
	# Rise
	# Unparent player
	# barriers down
	pass

func _process(delta):
	pass
