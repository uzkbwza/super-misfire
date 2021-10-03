extends StateInterface

onready var tween = $Tween

func enter():
	host.apply_impulse_angular(sign(Rng.rng.randi()) * 20)
	yield(get_tree().create_timer(0.8), "timeout")
	if !get_parent().queued_state_change:
		queue_state_change("alive")

func update(delta):
	host.apply_forces(delta)
	host.move_camera(delta)
	if host.dead:
		return "dead"
	
func exit():
	host.angular_accel = 0
	host.angular_vel = 0
	tween.interpolate_property(host, "global_rotation", host.global_rotation, 0, 0.35, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	host.global_rotation = 0
