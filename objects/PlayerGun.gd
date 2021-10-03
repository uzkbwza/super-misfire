extends Gun

class_name PlayerGun

onready var reload_sound = $ReloadSound
onready var next_bullet = get_new_bullet_type()
onready var blank_timer = $BlankTimer
var blank_buffered = false

func _ready():
#	add_bullet_type(load("res://objects/Bullets/Mags/Bomb.tres"))
#	add_bullet_type(load("res://objects/Bullets/Mags/Bee.tres"))
#	add_bullet_type(load("res://objects/Bullets/Mags/NinjaStar.tres"))
	pass

func shoot():
	.shoot()
	Utils.screenshake(0.2, Utils.ang2vec(global_rotation))

func shoot_blank():
	if !firing and blank_timer.is_stopped():
		var m = muzzle_flash.instance()
		var level = Utils.get_current_level()
		level.call_deferred("add_child", m)
		m.global_position = muzzle.global_position
		m.global_rotation = muzzle.global_rotation
		blank_timer.start()
	elif blank_timer.time_left < shot_buffer_time:
		blank_buffered = true
		
func reload(bullet: BulletType, init=false, new_bullet=false):
	if new_bullet:
		next_bullet = bullet
		get_parent().emit_signal("new_bullet", next_bullet)
		reload_sound.play()
		if !reloading:
			.reload(next_bullet, true)
		else:
			reloading_bullet = next_bullet
	elif !init:
		next_bullet = get_new_bullet_type()
		get_parent().emit_signal("new_bullet", next_bullet)
		if len(bullet_types) > 1:
			reload_sound.play()
		.reload(next_bullet, false)
	else:
		.reload(bullet, true)

func pickup(bullet: BulletType):
	add_bullet_type(bullet)
	reload(bullet, false, true)

func get_new_bullet_type():
	var new_type = bullet_types[Rng.random_choice(bullet_types.keys())]
	if new_type != current_bullet or len(bullet_types.keys()) <= 1:
		return new_type
	else:
		return get_new_bullet_type()

func _on_BlankTimer_timeout():
	if blank_buffered:
		shoot_blank()
		blank_buffered = false
	pass # Replace with function body.
