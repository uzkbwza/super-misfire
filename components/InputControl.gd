extends Node2D

onready var mouse_position = global_position
onready var host = get_parent()

func _process(delta):
	mouse_position = get_global_mouse_position()

func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		host.shoot(false)	
	if Input.is_action_just_pressed("blank"):
		host.shoot(true)
	var dir = Vector2()
	dir.x = Input.get_action_strength("r") - Input.get_action_strength("l")
	dir.y = Input.get_action_strength("d") - Input.get_action_strength("u")
	dir = dir.normalized()
	host.moving = bool(dir.length())
	host.moving_dir = dir
