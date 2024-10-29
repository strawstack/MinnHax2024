extends Node3D

var audioDir: Array[String]

var files = {}
func _ready():
	audioDir = [
		"A.mp3",
		"B.mp3",
		"BEG1.mp3",
		"BEG2.mp3",
		"BEG3.mp3",
		"BEG4.mp3",
		"BEG5.mp3",
		"BEG6.mp3",
		"BEG7.mp3",
		"BEG8.mp3",
		"BEG9.mp3",
		"BEG10.mp3",
		"BEG11.mp3",
		"BEG12.mp3",
		"BEG13.mp3",
		"bgm_main.mp3",
		"boss_vibration.mp3",
		"C.mp3",
		"camera_shutter.mp3",
		"D.mp3",
		"disco_cat.mp3",
		"E.mp3",
		"F.mp3",
		"G.mp3",
		"gun_cock.mp3",
		"H.mp3",
		"J.mp3",
		"K.mp3",
		"M.mp3",
		"mewtwo_voice.mp3",
		"N.mp3",
		"O.mp3",
		"P.mp3",
		"Q.mp3",
		"R.mp3",
		"S.mp3",
		"T1.mp3",
		"T2.mp3",
		"T3.mp3",
		"T4.mp3",
		"T5.mp3",
		"T6.mp3",
		"T7.mp3",
		"T8.mp3",
		"T9.mp3",
		"T10.mp3",
		"T11.mp3",
		"T12.mp3",
	]
	for filename in audioDir:
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
