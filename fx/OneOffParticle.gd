extends AnimatedSprite

onready var sound = $Sound
export var damage = 2
var objects_hit = []
export var knockback = 100

class Damager:
	var damage
	func _init(damage):
		self.damage = damage

func _ready():
	if sound.stream:
		Utils.play_sound_in_level(sound)
#	$Sound.play()
	playing = true
	frame = 0
	pass # Replace with function body.

func _on_OneOffParticle_animation_finished():
	queue_free()

func _on_Area2D_body_entered(body):
	if body is CharacterObject or body is Bee and !(body in objects_hit):
		body.hit_by(self, Utils.ang2vec(global_rotation) * knockback)
		objects_hit.append(body)
	pass # Replace with function body.


func _on_Timer_timeout():
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.
