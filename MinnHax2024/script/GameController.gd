extends Node3D

@export var tram: Node3D
@export var player_start_point: Node3D
@export var player: CharacterBody3D

func _ready():
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
