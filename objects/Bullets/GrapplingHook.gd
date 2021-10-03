extends Bullet

class_name GrapplingHook

export var spin_amount = 50
var attached_to = weakref(null)
var attach_offset = Vector2()
var stuck = false
export var reel_enemy_speed = 100
export var reel_player_speed = 100
export var exit_distance = 50

func begin():
	launch()
	$Sound.play()
#	sprite.play()
#	apply_impulse_angular(spin_amount * sign(Rng.range_f(-1, 1)))

func bounce():
	if !stuck:
		$Clang.play()
#	timer.start(timer.time_left * 0.75)
		Utils.play_effect("Slash", global_position)
		vel *= 0
		angular_vel *= 0
		sprite.rotation = Rng.random_angle()
		stuck = true
		damage = 2

func _physics_process(delta):
	global_rotation = (global_position - shooter.muzzle.global_position).angle()
	var attached_to_node = attached_to.get_ref()
	if attached_to_node and attached_to_node is BaseObject:
		vel = Vector2()
		global_position = attached_to_node.global_position + attach_offset
		attached_to_node.move_and_slide((shooter.muzzle.global_position - attached_to_node.global_position).normalized() * reel_enemy_speed)
		if global_position.distance_to(shooter.muzzle.global_position) < exit_distance * 2:
			exit()
#		hit(attached_to_node)
	elif stuck:
		if global_position.distance_to(shooter.muzzle.global_position) < exit_distance:
			exit()
		shooter.get_parent().move_and_slide((global_position - shooter.muzzle.global_position).normalized() * reel_player_speed)
		pass
	update()

func _draw():
	draw_line(Vector2(), to_local(shooter.muzzle.global_position), Color.black, 1, false)

func exit():
	.exit()

func hit(node):
	.hit(node)
#	if !stuck and !attached_to.get_ref():
#		damage *= 0.66
#		damage = max(damage, 1)
	if !stuck and node is CharacterObject and !attached_to.get_ref():
		attach_to(node)
		stuck = true

func attach_to(node):
	attached_to = weakref(node)
	attach_offset = node.to_local(global_position)
	damage = 2
