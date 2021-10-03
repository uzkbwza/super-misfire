extends EnemyCharacter
onready var hitbox = $Hitbox
#var hitting_player = true

export var shoot_distance = 300

func angle_gun():
	gun.look_at(aim_position)
	gun.flip_v = Utils.ang2vec(gun.rotation).x < 0
	gun.z_index = -1 if gun.flip_v else 1

func _on_AiCycle_timeout():
	var player = Utils.player_object
	if !can_see_player:
		path = Utils.current_level.nav.path_to_node(self, player)
		if path_line.visible:
			path_line.points = path
	elif global_position.distance_to(player.global_position) < shoot_distance:
		if Rng.percent(20) and !dead:
			gun.shoot()
