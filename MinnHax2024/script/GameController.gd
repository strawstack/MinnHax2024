extends Node3D

@export var tram: Node3D
@export var player_start_point: Node3D
@export var player: CharacterBody3D

@export var tower: Node3D

var towerTouched = false

var debug = true

func _ready():
	if debug:
		pass
	else:
		tram.start_tram()
		player.set_position(player_start_point.get_position())

func getPlayer():
	return player

func boardTram():
	player.reparent(tram)
	player.set_position(player_start_point.get_position())

func exitTram():
	player.reparent(self)

func _process(delta):
	pass

# Entering reception
func _on_reception_area_3d_body_entered(body):
	print("Entering reception")

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
