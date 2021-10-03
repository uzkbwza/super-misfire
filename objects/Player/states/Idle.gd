extends StateInterface


func enter():
	pass

func update(delta):
	if host.moving:
		host.sprite.animation = "walk"
	else:
		host.sprite.animation = "idle"

	host.move()
	host.angle_gun()
	host.move_camera(delta)
	host.apply_forces(delta)


func _on_Player_die():
	queue_state_change("dead")
	pass # Replace with function body.
