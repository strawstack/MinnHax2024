extends Node2D

func _ready():
	$leo_seat.set_visible(true)
	$ben_seat.set_visible(true)

func turnOn():
	$stones_wood_coals.set_visible(true)
	$flames.set_visible(true)
	$flames.play("fire")
	$PointLight2D.set_visible(true)
	$PointLight2D.startTweenGame()

func turnOff():
	$flames.set_visible(false)
	$flames.stop()
	$PointLight2D.set_visible(false)
