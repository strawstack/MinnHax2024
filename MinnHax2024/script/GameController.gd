extends Node3D

@export var player: CharacterBody3D
@export var playerCamera: Camera3D
@export var orby: Node3D

@export var tram: Node3D
@export var beam_elevator: Node3D
@export var photos: Node3D
@export var tower: Node3D

@export var player_start_point: Node3D
@export var walkingSimCameraPoint: Node3D
@export var arcadePlayerWait: Node3D

# Variables
var debug = true
var playerFrozen = false
var playingWalkingSim = false
var towerTouched = false

func _ready():
	if debug:
		pass
	else:
		tram.start_tram()
		player.set_position(player_start_point.get_position())

func _process(delta):
	if debug and Input.is_action_just_pressed("special"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if playingWalkingSim and Input.is_action_just_pressed("escape"):
		exitWalkingSim()

func isPlayerFrozen():
	return playerFrozen

func getPlayer():
	return player

func boardTram():
	player.reparent(tram)
	player.set_position(player_start_point.get_position())

func exitTram():
	player.reparent(self)

func playWalkingSim():
	playerFrozen = true
	
	# Reparent camera
	playerCamera.reparent(self)
	
	# Animate camera
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(playerCamera, "position", walkingSimCameraPoint.get_global_position(), 1)
	tween.tween_property(playerCamera, "rotation", walkingSimCameraPoint.get_global_rotation(), 1)
	
	# Reposition player
	player.set_position(arcadePlayerWait.get_global_position())
	player.set_rotation_degrees(Vector3(0, 0, 0))
	player.get_node("Camera3D").set_rotation_degrees(Vector3(0, 0, 0))
	
	playingWalkingSim = true

func callbackUnfreezePlayer():
	player.camera_anglev = 0 # reset to realign vertical look bounds
	playerFrozen = false
	playingWalkingSim = false

func exitWalkingSim():
	playerCamera.reparent(player.get_node("Camera3D"))
	# Animate camera
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(playerCamera, "position", Vector3.ZERO, 1)
	tween.tween_property(playerCamera, "rotation", Vector3.ZERO, 1)
	tween.tween_callback(callbackUnfreezePlayer)

#
# Triggers
#

# Entering reception
func _on_reception_area_3d_body_entered(body):
	orby.trackPlayer(true)
	orby.moveToName("r1")

# Entering GI
func _on_entering_gi_area_3d_body_entered(body):
	print("Entering GI")

# Exiting GI
func _on_exiting_gi_area_3d_body_entered(body):
	print("Exiting GI")

# Entering art
func _on_entering_art_area_3d_body_entered(body):
	print("Entering Art")

func _on_exiting_art_area_3d_body_entered(body):
	print("exiting_art")

func _on_entering_arcade_area_3d_body_entered(body):
	print("entering_arcade")

func _on_exiting_arcade_area_3d_body_entered(body):
	print("exiting_arcade")

func _on_entering_jenga_area_3d_body_entered(body):
	print("entering_jenga")

func _on_exiting_jenga_area_3d_body_entered(body):
	pass # Replace with function body.

func _on_entering_beginner_area_3d_body_entered(body):
	pass # Replace with function body.

func _on_hit_zone_area_3d_body_entered(body):
	if not towerTouched:
		towerTouched = true
		for block in tower.get_children():
			block.set_gravity_scale(0.5)

func _on_white_room_area_3d_body_entered(body):
	pass # Replace with function body.

func _on_entering_jail_area_3d_body_entered(body):
	pass # Replace with function body.

func _on_beam_area_area_3d_body_entered(body):
	beam_elevator.up()

func _on_walking_sim_enter_area_3d_body_entered(body):
	playWalkingSim()
