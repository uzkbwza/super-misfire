extends Bullet

class_name NinjaStar

export var spin_amount = 50
var attached_to = weakref(null)
var attach_offset = Vector2()
var stuck = false

func _ready():
	launch()
	sprite.play()
	apply_impulse_angular(spin_amount * sign(Rng.range_f(-1, 1)))

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
	var attached_to_node = attached_to.get_ref()
	if attached_to_node:
		vel = Vector2()
		global_position = attached_to_node.global_position + attach_offset
		
#		hit(attached_to_node)

func hit(node):
	.hit(node)
	if !stuck and !attached_to.get_ref():
		damage *= 0.66
		damage = max(damage, 1)
	if Rng.percent(10) and !stuck and node is CharacterObject and !attached_to.get_ref():
		attach_to(node)
		stuck = true

func attach_to(node):
	attached_to = weakref(node)
	attach_offset = node.to_local(global_position)
	damage = 2
