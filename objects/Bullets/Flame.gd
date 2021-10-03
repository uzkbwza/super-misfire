extends Bullet

class_name Flame

func begin():
	Utils.play_sound_in_level($Sound)
	sprite.play()
	sprite.speed_scale = Rng.range_f(0.9, 1.1)
	move_speed = Rng.range_f(move_speed, move_speed/2)
#	vel = shooter.get_parent().vel
	launch()
#	move_and_collide(vel.normalized() * 8)
	
func _on_Sprite_animation_finished():
	exit()
	pass # Replace with function body.

func bounce():
	vel /= 3

func hit(node):
	if node is EnemyCharacter or node is PlayerObject:
		node.apply_impulse(vel)
		Utils.apply_status_effect(node, "BurnStatus")
	elif node is BaseObject:
		node.hit_by(self, vel/2)


func _on_Sprite_frame_changed():
	if sprite.frame > 3:
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.
