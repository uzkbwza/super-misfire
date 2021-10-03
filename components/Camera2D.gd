extends Camera2D

export var screen_shake_default_amount = 9.0
var screen_shake_max_amount
var screen_shake_amount = 0
var screen_shake_time = 0
var screen_shake_time_length = 0
var screen_shake = Vector2()
var dir = null

func screenshake(seconds: float, dir=null, amount=screen_shake_default_amount):
	self.dir = dir
	screen_shake_max_amount = amount
	screen_shake_amount = screen_shake_max_amount
	screen_shake_time = seconds
	screen_shake_time_length = seconds


func _physics_process(delta):
	offset = Vector2()
	
	if screen_shake_time > 0:
		if dir is Vector2:
			screen_shake = dir * Rng.range_f(1, 0) * screen_shake_amount
			screen_shake += Vector2(-dir.x, dir.y) * Rng.range_f(-0.25, 0.25) * screen_shake_amount
		else:
			screen_shake = Vector2(Rng.range_f(-1, 1), Rng.range_f(-1, 1)) * screen_shake_amount

		screen_shake *= screen_shake_time / screen_shake_time_length
		offset += screen_shake
#		if TimeScale.slomo:
#			offset *= 0.5
		screen_shake_time -= delta
