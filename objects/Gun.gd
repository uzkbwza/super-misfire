extends AnimatedSprite

class_name Gun

onready var shoot_timer = $ShootTimer
onready var reload_timer = $ReloadTimer
onready var muzzle = $Muzzle
export var muzzle_flash = preload("res://fx/MuzzleFlash.tscn")
var bullet_types = {
}
var reloading_bullet

export(Resource) var default_bullet
onready var current_bullet = default_bullet
var bullets_left = 0
var firing = false
var reloading = false
var shot_buffered = false
var first_shot = true
onready var shoot_speed = current_bullet.shoot_speed
export(float) var reload_speed = 0.15
export var shot_buffer_time = 0.05

func reloaded():
	pass

func _ready():
	add_bullet_type(current_bullet)
	reload(current_bullet, true)

func reload(bullet: BulletType, init=false):
	reloading = true
	reload_timer.start(reload_speed)
	reloading_bullet = bullet
	if !init:
		yield(reload_timer, "timeout")
	current_bullet = reloading_bullet
	bullets_left = reloading_bullet.mag_size
	reloading = false
	first_shot = true
	reloaded()
	if shot_buffered:
		shoot()


func _process(delta):
	Debug.dbg("firing", firing)
	Debug.dbg("reloading", reloading)
	Debug.dbg("shot_buffered", shot_buffered)
	Debug.dbg("reload", reload_timer.wait_time)

func shoot():
	if reloading and reload_timer.time_left < shot_buffer_time:
		shot_buffered = true
	elif !firing and !reloading:
		shot_buffered = false
		firing = true
		
		var level = Utils.get_current_level()
		var b
		for i in range(current_bullet.bullets_per_shot):
			 b = spawn_bullet()
		get_parent().apply_impulse(-Utils.ang2vec(global_rotation) * current_bullet.pushback_amount)
		if first_shot or current_bullet.muzzle_flash_all_shots:
			var m = muzzle_flash.instance()
			level.call_deferred("add_child", m)
			m.global_position = muzzle.global_position
			m.global_rotation = muzzle.global_rotation
		if current_bullet.sound:
			$ShotSound.stream = current_bullet.sound
			$ShotSound.play()
		if current_bullet.wait_till_exit:
			yield(b, "exit")
		bullets_left -= 1
		if bullets_left > 0:
			shoot_timer.start(shoot_speed)
		else:
			firing = false
			reload(get_new_bullet_type())
		first_shot = false
			
func spawn_bullet():
	var b = current_bullet.scene.instance()
	var level = Utils.get_current_level()
	level.call_deferred("add_child", b)
	b.global_position = muzzle.global_position
	b.global_rotation = muzzle.global_rotation
	b.shooter = self
	return b

func add_bullet_type(bullet: BulletType):
	if !bullet_types.has(bullet.name):
		bullet_types[bullet.name] = bullet

func get_new_bullet_type():
	return current_bullet

func _on_ShootTimer_timeout():
	firing = false
	shoot()
