extends BaseObject
class_name CharacterObject

var status_effects = {}
var aim_position = Vector2()
var moving = false
var moving_dir = Vector2()

func move():
	sprite.flip_h = aim_position.x < global_position.x
	apply_force(moving_dir * accel_speed)

func die():
	.die()
	for status in status_effects.values():
		status.exit()
