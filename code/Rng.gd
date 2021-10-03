extends Node

# Declare member variables here. Examples:
onready var rng = RandomNumberGenerator.new()

func _enter_tree():
	randomize()
func _ready():
	rng.randomize()

func random_angle():
	return range_f(0, TAU)
	
func random_angle_centered():
	return range_f(0, TAU) - TAU/2

func random_vec(max_length=1):
	return Utils.ang2vec(random_angle()) * range_f(0, max_length)

func random_grid_dir(max_length=1):
	# picks a random direction on square grid
	return Vector2(range_i(-1, 1), range_i(-1, 1))
	
func random_grid_dir_cardinal(max_length=1, with_zero=false):
	# picks a random cardinal direction on square grid
	var dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	if with_zero:
		dirs.append(Vector2.ZERO)
	return random_choice(dirs)

func random_choice(array):
	return array[range_i(0, len(array) - 1)]

func percent(value):
	return range_f(0, 100) < value 
	
func f():
	return rng.randf()

func coin_flip():
	return rng.randi() % 2 == 0
	
func range_f(from: float, to: float):
	return rng.randf_range(from, to)
	
func randfn(mean: float = 0.0, deviation: float = 1.0):
	return rng.randfn(mean, deviation)
	
func i():
	return rng.randi()

func range_i(from: int, to: int):
	return rng.randi_range(from, to)
