extends Bullet

class_name Confetti

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func begin():
	launch()
	$DisableTimer.start()
	$Particles2D.emitting = true
	$Sound.play()
	pass # Replace with function body.

func hit(node):
	if node is BaseObject:
		node.hit_by(self, vel * 50)


func _on_DisableTimer_timeout():
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.
