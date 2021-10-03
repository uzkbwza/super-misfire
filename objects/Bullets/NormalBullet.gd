extends Bullet
export var variable_speed = false

func begin():
#	$Hitbox.set_collision_mask_bit(1, true)
	if variable_speed:
		apply_impulse(Rng.range_f(move_speed, move_speed/2.0) * Utils.ang2vec(global_rotation))
	else:
		launch()
		
func exit():
	queue_free()

func bounce():
	timer.start(timer.time_left * 0.6)
	Utils.play_effect("Slash", global_position)
	vel /= 1.5

func hit(node):
	.hit(node)
	if node is CharacterObject:
		exit()
