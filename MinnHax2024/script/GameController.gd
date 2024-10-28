extends Node3D

@export var player: CharacterBody3D
@export var playerCamera: Camera3D
@export var orby: Node3D
@export var audioLoad: Node3D
@export var handCamera: Node3D

@export var tram: Node3D
@export var beam_elevator: Node3D
@export var photos: Node3D
@export var tower: Node3D
@export var planet: MeshInstance3D

@export var player_start_point: Node3D
@export var walkingSimCameraPoint: Node3D
@export var arcadePlayerWait: Node3D
@export var jeffm_spheres: Array[Node3D]
@export var particles: Node3D

# Variables
var debug = true
var playerFrozen = false
var playingWalkingSim = false
var towerTouched = false
var isSpeaking = false
var playerHasCamera = true

# state tracking
var once = {}
var overlap = {}

# Waypoint
@export var maze_done: Node3D

# Triggers
@export var entering_gi: Area3D
@export var exiting_gi: Area3D
@export var entering_art: Area3D
@export var exiting_art: Area3D
@export var entering_arcade: Area3D
@export var exiting_arcade: Area3D
@export var entering_jenga: Area3D
@export var exiting_jenga: Area3D
@export var entering_beginner: Area3D
@export var exiting_knife: Area3D
@export var entering_gift: Area3D

@export var beginner_one: Area3D
@export var beginner_two: Area3D
@export var beginner_three: Area3D
@export var beginner_four: Area3D
@export var beginner_five: Area3D
@export var beginner_six: Area3D

@export var entering_jail: Area3D
@export var exiting_club: Area3D
@export var knife_trigger: Area3D
@export var entering_knife: Area3D

# Doors
@export var lobby_heart_door: Node3D
@export var art_heart_door: Node3D
@export var arcade_heart_door: Node3D
@export var jenga_heart_door: Node3D
@export var beginner_heart_door: Node3D
@export var beginner_back_door: Node3D
@export var jeffm_door: Node3D
@export var maze_door: Node3D
@export var jail_enter_door: Node3D
@export var jail_exit_door: Node3D
@export var knife_door: Node3D
@export var gift_door: Node3D

func _ready():
	if debug:
		orby.teleportToName("beam_elevator")
		orby.reparent(beam_elevator)
		orby.lookAtName("player")
		hasCamera(true)
	else:
		player.set_position(player_start_point.get_position())
		opening_tram_ride()

func hasCamera(value):
	playerHasCamera = value
	if playerHasCamera:
		handCamera.set_visible(true)
		player.gun.set_visible(false)
	else:
		handCamera.set_visible(false)
		player.gun.set_visible(true)

func opening_tram_ride():
	var totalDur = duration("A")
	totalDur += duration("B")
	totalDur += duration("C")
	totalDur += duration("D")
	totalDur += duration("E")
	totalDur += 3 + 1 + 1 + 1 + 3 + 2 # wait between clips
	
	planet.begin_rotate(totalDur)
	tram.start_tram(totalDur)
	
	await get_tree().create_timer(3.0).timeout
	await say("A")
	await get_tree().create_timer(1.0).timeout
	await say("B")
	await get_tree().create_timer(1.0).timeout
	await say("C")
	await get_tree().create_timer(1.0).timeout
	await say("D")
	await get_tree().create_timer(3.0).timeout
	await say("E")
	await get_tree().create_timer(2.0).timeout

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

func movePlayer(waypointNode):
	player.set_position(waypointNode.get_position())

func getAudio(clipName):
	return audioLoad.getAudio(clipName)

func waitOnArea(area3D):
	if area3D.name in overlap:
		return true
	else:
		await area3D.body_entered

func duration(clipName):
	var audioStream = getAudio(clipName)
	return audioStream.get_length()

func say(clipName):
	var audioStream = getAudio(clipName)
	$AudioStreamPlayer.set_stream(audioStream)
	isSpeaking = true
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	isSpeaking = false

#
# Signals
#

func onlyOnce(signalName):
	if not (signalName in once):
		once[signalName] = true
		return true
	return false

# Entering reception
func _on_reception_area_3d_body_entered(body):
	if onlyOnce("_on_reception_area_3d_body_entered"):
		orby.lookAtName("player")
		await orby.moveToName("r1")
		await orby.say("F") # Tour guide introduction, and lets start the tour
		await orby.lookAtAndMoveToName("pre_gi_heart")
		await orby.lookAtName("gi_heart")
		await lobby_heart_door.open()
		await orby.moveToName("gi_heart")
		await orby.lookAtAndMoveToName("mag_two")
		orby.lookAtName("player")
		await waitOnArea(entering_gi)
		await orby.say("G") # Talking about mag collection
		await get_tree().create_timer(1.0).timeout
		orby.say("H") # Meet me over by the door when you're ready
		await orby.lookAtAndMoveToName("pre_art_heart")
		await orby.lookAtName("player")
		await waitOnArea(exiting_gi)
		await art_heart_door.open()
		await orby.lookAtAndMoveToName("art_heart")
		await orby.lookAtAndMoveToName("art_one")
		orby.lookAtName("player")
		await waitOnArea(entering_art)
		
		await orby.say("J") # Art one dialogue
		
		await orby.lookAtAndMoveToName("art_two")
		orby.lookAtName("player")
		await orby.say("K") # Art two dialogue
		
		await orby.lookAtAndMoveToName("art_three")
		orby.lookAtName("player")
		await orby.say("M") # Art three dialogue
		await get_tree().create_timer(1.0).timeout
		
		orby.say("H") # Go to door to continue the tour
		await orby.lookAtAndMoveToName("pre_arcade_heart")
		orby.lookAtName("player")
		
		await waitOnArea(exiting_art)
		await arcade_heart_door.open()
		await orby.lookAtAndMoveToName("arcade_heart")
		await orby.lookAtAndMoveToName("arcade_machine")
		orby.lookAtName("player")
		await waitOnArea(entering_arcade)
		await orby.say("N") # Talking about walking simulator
		await get_tree().create_timer(1.0).timeout
		await orby.say("O") # Talking about walking simulator

		await orby.lookAtAndMoveToName("pre_jenga_heart")
		orby.lookAtName("player")
		
		await waitOnArea(exiting_arcade)
		await jenga_heart_door.open()
		await orby.lookAtAndMoveToName("jenga_heart")
		await orby.lookAtAndMoveToName("jenga_tower")
		orby.lookAtName("player")
		
		await waitOnArea(entering_jenga)
		
		await orby.say("P") # Talk about the tower
		await get_tree().create_timer(1.0).timeout
		
		await orby.say("Q") # Lets go to next section
		await orby.lookAtAndMoveToName("pre_beginner_heart")
		orby.lookAtName("player")
		
		await waitOnArea(exiting_jenga)
		await beginner_heart_door.open()

# Track entering_gi overlap
func _on_entering_gi_area_3d_body_entered(body):
	lobby_heart_door.close()
	overlap[entering_gi.name] = true

# Track exiting_gi overlap
func _on_exiting_gi_area_3d_body_entered(body):
	overlap[exiting_gi.name] = true
func _on_exiting_gi_area_3d_body_exited(body):
	overlap.erase(exiting_gi.name)

# Entering art
func _on_entering_art_area_3d_body_entered(body):
	art_heart_door.close()
	overlap[entering_art.name] = true

# Exiting art
func _on_exiting_art_area_3d_body_entered(body):
	overlap[exiting_art.name] = true
func _on_exiting_art_area_3d_body_exited(body):
	overlap.erase(exiting_art.name)

# Entering arcade
func _on_entering_arcade_area_3d_body_entered(body):
	arcade_heart_door.close() 
	overlap[entering_arcade.name] = true

# Exiting arcade
func _on_exiting_arcade_area_3d_body_entered(body):
	overlap[exiting_arcade.name] = true
func _on_exiting_arcade_area_3d_body_exited(body):
	overlap.erase(exiting_arcade.name)

func _on_entering_jenga_area_3d_body_entered(body):
	jenga_heart_door.close()
	overlap[entering_jenga.name] = true

# Exiting jenga
func _on_exiting_jenga_area_3d_body_entered(body):
	overlap[exiting_jenga.name] = true
func _on_exiting_jenga_area_3d_body_exited(body):
	overlap.erase(exiting_jenga.name)

func _on_entering_beginner_area_3d_body_entered(body):
	beginner_heart_door.close()
	beginner_back_door.close()
	overlap[entering_beginner.name] = true
	
	if onlyOnce("_on_entering_beginner_area_3d_body_entered"):
		await say("BEG1")
		await get_tree().create_timer(1.0).timeout
		await say("BEG2")
		jeffm_door.open()
		await waitOnArea(beginner_one)
		orby.teleportToName("beam_elevator")
		orby.reparent(beam_elevator)
		await say("BEG3")
		await waitOnArea(beginner_two)
		await say("BEG4")
		await waitOnArea(beginner_three)
		await say("BEG5")
		await waitOnArea(beginner_four)
		await say("BEG6")
		for js in jeffm_spheres:
			js.go()
		await get_tree().create_timer(3.0).timeout # Wait a bit for battle
		await say("BEG7")
		await get_tree().create_timer(5.0).timeout # Wait a bit for battle
		maze_door.open()
		await say("Q")
		await waitOnArea(beginner_five)
		await say("BEG8")
		await waitOnArea(beginner_six)
		await say("BEG9")
		await get_tree().create_timer(1.0).timeout # Wait before warping player
		movePlayer(maze_done)
		await entering_jail.body_entered
		await jail_enter_door.close()
		await get_tree().create_timer(1.0).timeout
		await say("BEG10")
		say("BEG11")
		jail_exit_door.open()

func _on_hit_zone_area_3d_body_entered(body):
	if not towerTouched:
		towerTouched = true
		for block in tower.get_children():
			block.set_gravity_scale(0.5)

func _on_white_room_area_3d_body_entered(body):
	pass # Replace with function body.

func _on_entering_jail_area_3d_body_entered(body):
	pass # Replace with function body.

func _on_walking_sim_enter_area_3d_body_entered(body):
	playWalkingSim()

func _on_beginner_one_area_3d_body_entered(body):
	overlap[beginner_one.name] = true

func _on_beginner_two_area_3d_body_entered(body):
	overlap[beginner_two.name] = true

func _on_beginner_three_area_3d_body_entered(body):
	overlap[beginner_three.name] = true

func _on_beginner_four_area_3d_body_entered(body):
	overlap[beginner_four.name] = true

func _on_beginner_five_area_3d_body_entered(body):
	overlap[beginner_five.name] = true

func _on_beginner_six_area_3d_body_entered(body):
	overlap[beginner_one.name] = true

func _on_beam_area_area_3d_body_entered(body):
	if onlyOnce("_on_beam_area_area_3d_body_entered"):
		jail_exit_door.close()
		var totalDur = duration("BEG12") + duration("BEG13") + 2 + duration("R")
		beam_elevator.up(totalDur)
		orby.reparent(self)
		await say("BEG12")
		await say("BEG13")
		await get_tree().create_timer(1.0).timeout
		await orby.say("R")
		await get_tree().create_timer(1.0).timeout # Explore club
		await orby.say("S") # Head to the door
		orby.lookAtAndMoveToName("club_heart")
		orby.lookAtName("player")
		await waitOnArea(exiting_club)
		await knife_door.open()
		orby.lookAtAndMoveToName("knife_side")

func _on_entering_knife_area_3d_body_entered(body):
	knife_door.close()
	orby.lookAtName("player")
	await orby.say("T1") # Knife room intro
	await orby.say("T2") # Knife room intro
	await orby.say("T3") # Knife room intro
	orby.lookAtName("knife_itself")
	await orby.say("T4")
	await get_tree().create_timer(0.5).timeout
	await orby.say("T5")
	await get_tree().create_timer(0.5).timeout
	await orby.say("T6")
	await get_tree().create_timer(0.5).timeout
	
	await waitOnArea(knife_trigger) # Knife battle start
	await orby.say("T7")
	
	orby.knifeBattle() # wait until battle is done
	await orby.battle_complete
	
	await waitOnArea(exiting_knife)
	await gift_door.open()
	await entering_gift.body_entered
	gift_door.close()

func _on_exiting_club_area_3d_body_entered(body):
	overlap[exiting_club.name] = true
func _on_exiting_club_area_3d_body_exited(body):
	overlap.erase(exiting_club.name)

func _on_knife_trigger_area_3d_body_entered(body):
	overlap[knife_trigger.name] = true

func _on_exiting_knife_area_3d_body_entered(body):
	overlap[exiting_knife.name] = true
func _on_exiting_knife_area_3d_body_exited(body):
	overlap.erase(exiting_knife.name)


