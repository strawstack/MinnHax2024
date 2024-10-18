extends Node3D

@export var tram: Node3D
@export var player_start_point: Node3D
@export var player: CharacterBody3D

func _ready():
	#tram.start_tram()
	#player.set_position(player_start_point.get_position())
	pass

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
