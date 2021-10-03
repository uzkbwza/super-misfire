extends Pickup

export var health_amount = 6

func consumed_by(node: PlayerObject):
	node.add_hp(health_amount)
	for status in node.status_effects.values():
		if is_instance_valid(status):
			status.exit()
	pass
