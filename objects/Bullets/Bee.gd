extends Bullet

class_name Bee
var target = weakref(null)
onready var search_box_shape = $SearchBox/CollisionShape2D
onready var search_box = $SearchBox
var searching = false
onready var search_timer = $SearchTimer
export var search_speed = 500
export var wiggle_speed = 4
export var num_hits = 3
func _ready():
	timer.start(Rng.range_f(lifetime, lifetime * 0.80))
	launch(Rng.range_f(move_speed/3.5, move_speed))
	search_timer.start(Rng.range_f(search_timer.wait_time, search_timer.wait_time / 2.0))
	$Buzz.play()
	pass
	
func hit(node):
	if node is CharacterObject:
		if num_hits <= 0:
			exit()
		if Rng.percent(33.33):
			node.hit_by(self, vel/2)
		num_hits -= 1
		var normal = (global_position - node.global_position).normalized()
		vel = vel.bounce(normal)
		vel = vel.normalized() * Rng.range_f(move_speed/10, move_speed)

func _physics_process(delta):
	var t = target.get_ref()
	if t:
		accel_towards(t, accel_speed)
		if t.state_machine.state.state_name == "dead":
			target = weakref(null)
	else:
		target = weakref(null)
		searching = true
		if search_box_shape.disabled:
			search_box_shape.set_deferred("disabled", false)
		if searching:
			vel = vel.rotated(Rng.range_f(-wiggle_speed * delta, wiggle_speed * delta))
			apply_force(Utils.ang2vec(global_rotation) * search_speed)
	rotation_flip()
	rotate_forward()

func _on_SearchBox_body_entered(body):
	if body is CharacterObject:
		target = weakref(body)
		if not body is PlayerObject:
			search_box_shape.set_deferred("disabled", true)
		searching = false

func _on_SearchTimer_timeout():
	searching = true
	set_collision_layer_bit(2, true)
	set_collision_layer_bit(3, true)
	search_box_shape.set_deferred("disabled", false)
	pass # Replace with function body.

func die():
	.die()
	queue_free()


func _on_BetrayTimer_timeout():
	search_box.set_collision_mask_bit(1, true)
	pass # Replace with function body.
