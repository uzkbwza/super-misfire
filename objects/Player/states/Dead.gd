extends StateInterface

func enter():
	host.apply_impulse_angular(Rng.range_f(-20, 20))
	host.apply_impulse(Utils.ang2vec(Rng.random_angle()) * 2000)
	host.set_collision_layer_bit(2, false)
	host.z_index -= 1
	host.sprite.animation = "dead"
	host.camera.position = Vector2()

func update(delta):
	if host.speed > 0:
		host.apply_forces(delta)
