extends AudioStreamPlayer

class_name VariableSound

export var pitch_variation = 0.1
onready var starting_pitch = pitch_scale
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func play(p=0.0):
	pitch_scale = starting_pitch + Rng.rng.randf_range(-pitch_variation, pitch_variation)
	.play(p)
