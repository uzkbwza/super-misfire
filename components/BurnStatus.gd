extends StatusEffect

class_name BurnStatus

export var damage = 1
#export var player_lifetime = 1.5
onready var animation_player = $AnimationPlayer
var exited = false

func begin():
#	$Sound.play()
	if is_instance_valid(host.sprite):
		host.sprite.material = material.duplicate(true)
	pass
	yield(get_tree(), "physics_frame")
	_on_BurnCycle_timeout()
	
func _process(delta):
	if host.dead and !exited:
		$BurnCycle.stop()
		exit()
		return
	if is_instance_valid(host.sprite) and host.sprite.get_material():
		host.sprite.get_material().set_shader_param("active", material.get_shader_param("active"))
	
func _on_BurnCycle_timeout():
	if $FlameFx.emitting:
		$Sound.play()
		host.hit_by(self)
		animation_player.stop(true)
		animation_player.play("burn")

func exit():
	exited = true
	$FlameFx.emitting = false	
	host.status_effects.erase(get_name())
	yield(get_tree().create_timer(1), "timeout")
	if is_instance_valid(host.sprite):
		host.sprite.material = null
	queue_free()
	
func _on_LifetimeTimer_timeout():
	if host is PlayerObject:
		exit()
	pass # Replace with function body.


func _on_SpreadBox_body_entered(body):
	if body != host: 
		if body is CharacterObject and $FlameFx.emitting:
			Utils.apply_status_effect(body, "BurnStatus")
		elif body is BaseObject:
			body.hit_by(self)
	pass # Replace with function body.
