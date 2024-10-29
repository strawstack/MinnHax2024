extends Node3D

@export var timer: Timer

var gc
func _ready():
	gc = get_tree().get_root().get_node("main")

func _process(delta):
	pass

func _on_timer_timeout():
	for rb in get_children():
		rb.add_collision_exception_with(gc.getPlayer())
