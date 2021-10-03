extends BaseObject

class_name Explosion

var bodies_hit = []
export var knockback_amount = 2000

func _ready():
	yield(get_tree(), "physics_frame")
	sprite.play()
	Utils.play_sound_in_level($Sound)
	Utils.current_camera.screenshake(0.3)
	Utils.current_level.explode_walls(global_position)

func _on_RemoveHitboxTimer_timeout():
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)

func _on_Hitbox_body_entered(body):
	if body is BaseObject:
		var dir = (body.global_position - global_position).normalized()
		var knockback = knockback_amount * dir
		body.move_and_collide(dir * 10)
		body.hit_by(self, knockback)
	pass # Replace with function body.


func _on_WaveTimer_timeout():
	var pos = global_position
	if scale.x >= 1.25:
		var dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		var offset = 32 * scale.x
		for dir in dirs:
			yield(get_tree().create_timer(0.075), "timeout")
			Utils.explode(pos + dir * offset, scale * 0.75)



func _on_ExitTimer_timeout():
	queue_free()
