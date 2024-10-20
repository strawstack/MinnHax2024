extends Node3D

@export var door: MeshInstance3D
@export var barrier: StaticBody3D

@export var openY = 10.667
@export var closeY = 4.667

@export var startOpen: bool = false

var gc
func _ready():
	gc = get_tree().get_root().get_node("main")

	if startOpen:
		open()
		isOpen = true

func open():
	toggleBlocking(false)
	var tween = create_tween()
	var pos = door.get_position()
	pos.y = openY
	tween.tween_property(door, "position", pos, 0.5)

func close():
	toggleBlocking(true)
	var tween = create_tween()
	var pos = door.get_position()
	pos.y = closeY
	tween.tween_property(door, "position", pos, 0.5)

var isOpen = false
func _process(delta):
	if gc.debug and Input.is_action_just_pressed("run"):
		if isOpen:
			close()
			isOpen = false
		else:
			open()
			isOpen = true

func toggleBlocking(state):
	if state == true:
		barrier.remove_collision_exception_with(gc.getPlayer())
	else:
		barrier.add_collision_exception_with(gc.getPlayer())
