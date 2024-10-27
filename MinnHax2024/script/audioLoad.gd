extends Node3D

var audioDir:DirAccess = DirAccess.open("res://audio")

var files = {}
func _ready():
	for filename in audioDir.get_files():
		var fname = getName(filename)
		if fname != null:
			files[fname] = load("res://audio/" + filename)

func getName(fileName):
	if ".import" in fileName:
		return null
	return fileName.split(".")[0]

func getAudio(clipName):
	return files[clipName]

func _process(delta):
	pass
