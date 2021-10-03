extends Bullet


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var launches = 5

func _physics_process(delta):
	global_rotation = 0

func begin():
	launch()

func hit(node):
	if node is EnemyCharacter or node is PlayerObject:
		if !node.dead:
			if node.state_machine.state.state_name == "alive":
				node.state_machine.state.queue_state_change("bananaPeelSlip")
				apply_impulse(node.vel * 4)
				Utils.play_sound_in_level($Sound)
				launches -= 1
				if launches <= 0:
					exit()
			yield(get_tree().create_timer(0.35), "timeout")
			node.hit_by(self)
