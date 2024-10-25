extends Node3D

@export var end_height: int
@export var barriers: Array[StaticBody3D]

var gc
var player
func _ready():
	gc = get_tree().get_root().get_node("main")
	player = gc.getPlayer()
	for barrier in barriers:
		barrier.add_collision_exception_with(player)

func elevator_done():
	# Unparent player
	player.reparent(gc)
	
	# barriers down
	for barrier in barriers:
		barrier.add_collision_exception_with(player)

func up():
	for barrier in barriers:
		barrier.remove_collision_exception_with(player)
	
	# reparent player
	player.reparent(self)

	var tween = get_tree().create_tween()
	var pos = get_position()
	pos.y = end_height
	tween.tween_property(self, "position", pos, 10)
	tween.tween_callback(elevator_done)
	await tween.finished

func _process(delta):
	pass
