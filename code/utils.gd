extends Node

var current_level
var current_camera
var player_object
var default_pickup_chance = 5
var begun = false
var player

signal done_waiting()
var effects = {
	"Slash": preload("res://fx/Slash.tscn")
}

static func map(value, istart, istop, ostart, ostop):
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))

static func tree_set_all_process(p_node: Node, p_active: bool, p_self_too: bool = false) -> void:
	if not p_node:
		push_error("p_node is empty")
		return
	var p = p_node.is_processing()
	var pp = p_node.is_physics_processing()
	p_node.propagate_call("set_process", [p_active])
	p_node.propagate_call("set_physics_process", [p_active])
	if not p_self_too:
		p_node.set_process(p)
		p_node.set_physics_process(pp)

static func snap(value, step):
	return round(value / step) * step

static func approach(a, b, amount):
	if a < b:
		a += amount
		if a > b:
			return b
	else:
		a -= amount
		if a < b:
			return b
	return a

static func ang2vec(angle):
	return Vector2(cos(angle), sin(angle))

static func get_angle_from_to(node, position):
	var target = node.get_angle_to(position)
	target = target if abs(target) < PI else target + TAU * -sign(target)
	return target
	
static func angle_diff(from, to):
	return fposmod(to-from + PI, PI*2) - PI
	
static func comma_sep(number):
	var string = str(int(number))
	var mod = string.length() % 3
	var res = ""
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]
	return res

static func wave(from, to, duration, offset):
	var t = OS.get_ticks_msec() / 1000.0
	var a = (to - from) * 0.5
	return from + a + sin((((t) + duration * offset) / duration) * TAU) * a

static func frames(num):
	return num * 0.016
	
func set_music(button_pressed):
	if !button_pressed:
		player.stop()
	else:
		player.play()

func get_current_level():
	return current_level

func screenshake(seconds: float, dir=null, amount=current_camera.screen_shake_default_amount):
	current_camera.screenshake(seconds, dir, amount)

func play_sound_in_level(sound):
	call_deferred("_play_sound_in_level", sound)
	
func _play_sound_in_level(sound_: Node):
	var sound = sound_.duplicate()
	if sound is Node2D:
		sound.global_position = sound_.global_position
	get_current_level().add_child(sound)
	sound.connect("finished", sound, "queue_free")
	sound.play()

func is_in_range(val, min_, max_):
	return val >= min_ and val < max_

func wait(time: float):
	yield(get_tree().create_timer(time), "timeout")
	emit_signal("done_waiting")

func explode(global_position, scale=1):
	if !scale is Vector2:
		scale = Vector2(scale, scale)		
	var explosion = preload("res://objects/Explosion.tscn").instance()
	get_current_level().call_deferred("add_child", explosion)
	explosion.global_position = global_position
	explosion.scale = scale
	explosion.damage = 5 * scale.x

func play_effect(effect: String, global_position):
	var effect_instance = effects[effect].instance()
	get_current_level().call_deferred("add_child", effect_instance)
	effect_instance.global_position = global_position

func place_in_level(scene, global_position):
	var scene_instance = scene.instance()
	get_current_level().call_deferred("add_child", scene_instance)
	scene_instance.global_position = global_position

func move_to_level(node):
	call_deferred("_move_to_level", node)

func _move_to_level(node):
	node.get_parent().remove_child(node)
	get_current_level().add_child(node)

func pickup_spawn(global_position, chance=default_pickup_chance):
	if !Rng.percent(chance):
		return
	default_pickup_chance = 8
	var pickups = {
		"Bullet": preload("res://objects/BulletPickup.tscn")
	}
	place_in_level(pickups["Bullet"], global_position)

func apply_status_effect(node: Node, status):
	var status_effects = {
		"BurnStatus": preload("res://components/BurnStatus.tscn"),
	}
	var effect_instance = status_effects[status].instance()
	if node.status_effects.has(status):
		if is_instance_valid(node.status_effects.get(status)):
			node.status_effects[status].get_node("LifetimeTimer").start(effect_instance.lifetime)
			effect_instance.queue_free()
	else:
		node.call_deferred("add_child", effect_instance)

static func remove_duplicates(array: Array):
	var seen = []
	var new = []
	for i in array.size():
		var value = array[i]
		if value in seen:
			continue
		seen.append(value)
		new.append(value)
	return new
