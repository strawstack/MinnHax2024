extends Node3D

@export var resource: Array[Resource]

var files = {}

func _ready():
	for res in resource:
		files[getName(res)] = res

func getName(resource):
	var split = resource.get_path().split("/")
	var file = split[split.size() - 1]
	var fileName = file.split(".")[0]
	return fileName

func getAudio(clipName):
	return files[clipName]

func _process(delta):
	pass
