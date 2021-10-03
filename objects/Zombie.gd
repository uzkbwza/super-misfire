extends EnemyCharacter
onready var hitbox = $Hitbox
var hitting_player = true

func _on_Hitbox_body_entered(body):
	if !active or state_machine.state.state_name != "alive":
		return
	if body is PlayerObject:
		body.hit_by(self)
		hitting_player = true
		$HitCycle.start()
	pass # Replace with function body.


func _on_Hitbox_body_exited(body):
	if body is PlayerObject:
		hitting_player = false
		$HitCycle.stop()
	pass # Replace with function body.


func _on_HitCycle_timeout():
	if dead:
		$HitCycle.stop()
		return
	if hitting_player:
		$HitCycle.start()
		var colliders = hitbox.get_overlapping_bodies()
		if Utils.player_object in colliders:
			Utils.player_object.hit_by(self)
	pass # Replace with function body.
