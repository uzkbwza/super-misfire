extends StateInterface
var has_gun

func enter():
	has_gun = is_instance_valid(host.gun)

func update(delta):
	if !host.active:
		return
	if host.moving:
		host.sprite.animation = "walk"
	else:
		host.sprite.animation = "idle"
	if has_gun:
		host.angle_gun()
	host.move()
	host.apply_force(host.moving_dir * host.accel_speed)
	host.apply_forces(delta, false)


func _on_EnemyCharacter_die():
	queue_state_change("dead")
	pass # Replace with function body.
