extends BaseObject

class_name Pickup
var pulling = weakref(null)

func _ready():
	sprite.play()
	$PushBox.add_collision_exception_with(self)

func _on_PickupBox_body_entered(body):
	if body is PlayerObject:
		Utils.play_sound_in_level($Sound)
		consumed_by(body)
		queue_free()

func consumed_by(node: PlayerObject):
	pass

func _physics_process(delta):
	apply_forces(delta)
	var body_pulling = pulling.get_ref()
	if body_pulling:
		accel_towards(body_pulling, accel_speed)

func _on_PullBox_body_entered(body):
	if body is PlayerObject:
		pulling = weakref(body)
	pass # Replace with function body.


func _on_PullBox_body_exited(body):
	if body == pulling.get_ref():
		pulling = weakref(null)
	pass # Replace with function body.
