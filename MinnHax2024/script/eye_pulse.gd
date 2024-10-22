extends MeshInstance3D

@export var orby: Node3D
@export var omniLight3D: OmniLight3D

var audioEffect: AudioEffectInstance
var activeMaterial: StandardMaterial3D

var MULT = 180
var speed = 10
var resting_glow = 0.3

func _ready():
	audioEffect = AudioServer.get_bus_effect_instance(1, 0) 
	activeMaterial = get_active_material(0)

func _process(_delta):
	if orby.isSpeaking:
		var mag = audioEffect.get_magnitude_for_frequency_range(0, 22000).length()
		var eng: float = activeMaterial.get_emission_energy_multiplier()
		var value = lerp(eng, clamp(mag * MULT, 0.0, 1.0), _delta * speed)
		activeMaterial.set_emission_energy_multiplier(value)
		omniLight3D.set_param(Light3D.PARAM_ENERGY, value * 6)
	else:
		activeMaterial.set_emission_energy_multiplier(resting_glow)
		omniLight3D.set_param(Light3D.PARAM_ENERGY, resting_glow * 6)
