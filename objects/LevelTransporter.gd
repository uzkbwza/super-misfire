extends BaseObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.rotation += 5 * delta
	$Sprite2.rotation -= 7.7 * delta
	pass


func _on_PlayerDetector_body_entered(body):
	if body is PlayerObject:
		get_parent().descend()
	pass # Replace with function body.


func _on_Timer_timeout():
	$PlayerDetector.set_collision_mask_bit(1, true)
	pass # Replace with function body.
