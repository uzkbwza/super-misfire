extends StateInterface

onready var timer = $Timer

func enter():
	host.apply_impulse_angular(sign(Rng.rng.randi()) * 20)
	timer.start()
		
func update(delta):
	host.apply_forces(delta)
	if host.dead:
		return "dead"

func exit():
#	tween.interpolate_property(host, "global_rotation", host.global_rotation, 0, 0.35, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
#	tween.start()
	host.global_rotation = 0
	host.angular_vel = 0

func _on_Timer_timeout():
	if !host.dead:
		queue_state_change("alive")
	pass # Replace with function body.
