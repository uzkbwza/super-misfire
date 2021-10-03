extends Node2D

onready var host = get_parent()

func _physics_process(delta):
	host.aim_position = Utils.player_object.global_position
	var dir = Vector2()
	dir = dir.normalized()
	host.moving = bool(dir.length())
	host.moving_dir = dir
