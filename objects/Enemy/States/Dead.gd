extends StateInterface

func enter():
	host.active = false
	host.apply_impulse_angular(Rng.range_f(-20, 20))
	host.set_collision_layer_bit(2, false)
	host.z_index -= 1
	host.sprite.animation = "dead"

func update(delta):
	if host.speed > 0:
		host.apply_forces(delta)
