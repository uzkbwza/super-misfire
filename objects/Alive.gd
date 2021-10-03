extends "res://objects/Enemy/States/Alive.gd"

func update(delta):
	.update(delta)
	host.angle_gun()
