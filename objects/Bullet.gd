extends BaseObject

class_name Bullet

export var move_speed = 500
export(float) var lifetime = 1.0
export(float) var spread = 0.0
onready var timer = $LifeTimer
var shooter
signal exit()

func apply_forces_bullet(delta):
#	var fraction = Engine.get_physics_interpolation_fraction()
	prev_vel = vel
	#	print(just_jumped)
	vel += friction * -(vel.normalized()) * delta
	
	prev_speed = speed
	angular_vel += angular_impulses
	vel += impulses
	vel += accel * delta
	
	if max_speed:
		vel = vel.clamped(max_speed)
#	global_position = LevelManager.clamp_to_bounds(global_position)
	var collision = move_and_collide(vel * delta)
	if collision:
		vel = vel.bounce(collision.normal)
		global_rotation = vel.angle()
		hit_wall(collision)
		bounce()
	speed = vel.length()

	prev_accel = accel
	accel = Vector2(0, 0)
	impulses = Vector2(0, 0)
	angular_impulses = 0
	_turn(delta)
	rotate(angular_vel * delta)

func bounce():
	pass

func _physics_process(delta):
	apply_forces_bullet(delta)

func launch(speed=move_speed):
	apply_impulse(speed * Utils.ang2vec(global_rotation))

func _ready():
	timer.start(lifetime)
	rotation += Rng.range_f(-spread, spread)
	sprite.frame = 0
	sprite.play()
	begin()
	pass

func begin():
	pass

func exit():
	emit_signal("exit")
	queue_free()
	pass

func hit_wall(wall):
	pass

func hit(node):
	if node is BaseObject:
		node.hit_by(self, vel/3)
	
func travel(delta):
#	move_and_collide(move_speed * delta * Utils.ang2vec(global_rotation))
	pass

func _on_LifeTimer_timeout():
	exit()
	pass # Replace with function body.


func _on_Hitbox_body_entered(body):
	if body != self:
		hit(body)
	pass # Replace with function body.
