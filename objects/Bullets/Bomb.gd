extends Bullet

class_name Bomb

export var spin_amount = 100


func begin():
	launch()
	apply_impulse_angular(Rng.range_f(-spin_amount, spin_amount))
#	apply_impulse(rotation)


func _on_Sprite_animation_finished():
	exit()
	pass # Replace with function body.

func exit():
	Utils.explode(global_position, 1.5)
	queue_free()

func hit(node):
	.hit(node)
	if node is CharacterObject:
		exit()

func die():
	exit()
