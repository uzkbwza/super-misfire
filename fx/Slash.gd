extends "res://fx/OneOffParticle.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var offset_amount = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = Rng.random_angle()
	offset = Rng.random_vec(offset_amount)
	scale = Vector2.ONE * Rng.range_f(0.75, 1.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
