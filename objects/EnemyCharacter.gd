extends CharacterObject

class_name EnemyCharacter
var can_see_player = false
onready var raycast = $RayCast2D
onready var gun = get_node_or_null("Gun")
var path = []
onready var path_line = $Line2D
var active = false
var delay_time = 2

func _ready():
	$AiStartupDelay.start(Rng.range_f(0.01, delay_time))
	$PushBox.add_collision_exception_with(self)
	
	if path_line.visible:
		Utils.move_to_level(path_line)
	pass
	
func _on_Sprite_frame_changed():
	if sprite.animation == "walk":
		Utils.play_sound_in_level($Footstep)

func get_path_to(player):
	raycast.look_at(Utils.player_object.global_position)
	var collider = raycast.get_collider()
	can_see_player = collider is Node and collider.is_in_group("player")
	$DebugLabel.text = collider.name if collider else ""
	if !can_see_player:
		if path.size() > 1:
			moving_dir = global_position.direction_to(path[1])
			if close_enough_to_path():
				path.remove(0)
		else:
			moving_dir = Vector2()
	else:
		moving_dir = (player.global_position - global_position)
	moving_dir = moving_dir.normalized()
	
func _physics_process(delta):
	active = active and !dead and state_machine.state.state_name == "alive"
	var player = Utils.player_object
	get_path_to(player)
	moving = bool(moving_dir.length())

func hit_by(node, knockback=null):
	.hit_by(node, knockback)
	if !dead:
		active = true

func close_enough_to_path():
	return path.size() and position.distance_to(path[0]) < 10.0

func _on_AiCycle_timeout():
	var player = Utils.player_object
	if !can_see_player:
		path = Utils.current_level.nav.path_to_node(self, player)
		if path_line.visible:
			path_line.points = path

func angle_gun():
	gun.look_at(aim_position)
	gun.flip_v = Utils.ang2vec(gun.rotation).x < 0
	gun.z_index = -1 if gun.flip_v else 1

func die():
	if !dead:
		if is_instance_valid($PushBox):
			$PushBox.queue_free()
		if is_instance_valid($Hitbox):
			$Hitbox.queue_free()
		Utils.pickup_spawn(global_position)
		get_parent().add_kill()
	.die()

func _on_PlayerSearch_body_entered(body):
	active = true
	pass # Replace with function body.


func _on_AiStartupDelay_timeout():
	_on_AiCycle_timeout()
	$AiCycle.start()
	pass # Replace with function body.
