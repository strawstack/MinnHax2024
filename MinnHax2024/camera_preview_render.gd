extends Sprite3D

@export var subview: SubViewport

func _ready():
	pass

func _process(delta):
	set_texture(subview.get_texture())
