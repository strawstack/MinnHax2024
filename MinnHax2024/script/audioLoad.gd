extends Node3D

var audioDir: Array[String]

var files = {}

signal audio_done

func _ready():
	pass

func loadAudio():
	var pre_lst = [
	preload("res://audio/A.mp3"),
	preload("res://audio/B.mp3"),
	preload("res://audio/BEG1.mp3"),
	preload("res://audio/BEG2.mp3"),
	preload("res://audio/BEG3.mp3"),
	preload("res://audio/BEG4.mp3"),
	preload("res://audio/BEG5.mp3"),
	preload("res://audio/BEG6.mp3"),
	preload("res://audio/BEG7.mp3"),
	preload("res://audio/BEG8.mp3"),
	preload("res://audio/BEG9.mp3"),
	preload("res://audio/BEG10.mp3"),
	preload("res://audio/BEG11.mp3"),
	preload("res://audio/BEG12.mp3"),
	preload("res://audio/BEG13.mp3"),
	preload("res://audio/bgm_main.mp3"),
	preload("res://audio/boss_vibration.mp3"),
	preload("res://audio/C.mp3"),
	preload("res://audio/camera_shutter.mp3"),
	preload("res://audio/D.mp3"),
	preload("res://audio/disco_cat.mp3"),
	preload("res://audio/E.mp3"),
	preload("res://audio/F.mp3"),
	preload("res://audio/G.mp3"),
	preload("res://audio/gun_cock.mp3"),
	preload("res://audio/H.mp3"),
	preload("res://audio/J.mp3"),
	preload("res://audio/K.mp3"),
	preload("res://audio/M.mp3"),
	preload("res://audio/mewtwo_voice.mp3"),
	preload("res://audio/N.mp3"),
	preload("res://audio/O.mp3"),
	preload("res://audio/P.mp3"),
	preload("res://audio/Q.mp3"),
	preload("res://audio/R.mp3"),
	preload("res://audio/S.mp3"),
	preload("res://audio/T1.mp3"),
	preload("res://audio/T2.mp3"),
	preload("res://audio/T3.mp3"),
	preload("res://audio/T4.mp3"),
	preload("res://audio/T5.mp3"),
	preload("res://audio/T6.mp3"),
	preload("res://audio/T7.mp3"),
	preload("res://audio/T8.mp3"),
	preload("res://audio/T9.mp3"),
	preload("res://audio/T10.mp3"),
	preload("res://audio/T11.mp3"),
	preload("res://audio/T12.mp3"),
	]
	
	for file in pre_lst:
		var fname = getName(file.resource_path)
		if fname != null:
			files[fname] = file
	
	audio_done.emit()

func getName(fileName):
	var sep = fileName.split("/")
	var fileExt = sep[sep.size() - 1]
	return fileExt.split(".")[0]

func getAudio(clipName):
	return files[clipName]

func _process(delta):
	pass
