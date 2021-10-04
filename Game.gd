extends YSort

class_name Game
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var debug = true
onready var crosshair = $CanvasLayer/Crosshair
onready var next_bullet_display = $CanvasLayer/Bullet
onready var heart_display = $CanvasLayer/Hearts
#onready var heart_display2 = $CanvasLayer/Hearts
onready var player = $Player
onready var map = $Navigation2D/Map
onready var nav = $Navigation2D
onready var tween = $Safe/Tween
export var level_size = 20
export var max_level_size = 60
export var default_num_zombies = 10
export(int) var num_zombies = default_num_zombies
export var max_pickup_chance = 14
var total_kills = 0
var level_kills = 0
var dead = false

func descend():
	$CanvasLayer/PauseMenu/Stuck.disabled = false
	if player.dead:
		return
	level_size = Utils.approach(level_size, max_level_size, 5)
	num_zombies = (default_num_zombies * log((map.current_depth+2)/500.0) + 60) * 4.5 # voodoo
	Debug.dbg("num_zombies", num_zombies)
	map.walk_length *= 1.5
	Utils.default_pickup_chance = Utils.approach(Utils.default_pickup_chance, 10, 1)
	map.walk_length = min(map.walk_length, 900)
	Debug.dbg("level_size", level_size)
	Debug.dbg("walk_length", map.walk_length)
	change_level(map.current_depth + 1, level_size, true)
	pass

func add_kill():
	total_kills += 1
	level_kills += 1
	$"CanvasLayer/Ur die/Kills/Label".text = str(total_kills)
	$CanvasLayer/PauseMenu/Kills/Label.text = str(total_kills)

func populate():
	spawn("LevelTransporter", map.staircase_pos)
	for i in range(num_zombies):
		spawn("Zombie")
	for i in range(num_zombies/30):
		spawn("BigZombie")
	if map.current_depth > 2:
		for i in range(num_zombies/10):
			spawn("Gunman")
	spawn("HealthPickup")

func spawn(type, cell=null, offset=Vector2()):
	var types = {
		"EnemyCharacter": preload("res://objects/EnemyCharacter.tscn"),
		"Zombie": preload("res://objects/Zombie.tscn"),
		"Gunman": preload("res://objects/Gunman.tscn"),
		"BigZombie": preload("res://objects/BigZombie.tscn"),
		"LevelTransporter": preload("res://objects/LevelTransporter.tscn"),
#		"Pickup": preload("res://objects/Pickup.tscn"),
		"BulletPickup": preload("res://objects/BulletPickup.tscn"),
		"HealthPickup": preload("res://objects/HealthPickup.tscn")
	}
	var space
	if !cell:
		space = map.get_open_space()
		while space.distance_to(player.global_position) < 200:
			space = map.get_open_space()
	else:
		space = map.get_world_pos(cell)
	Utils.place_in_level(types[type], space + Vector2(16, 16) + Rng.random_vec(8) + offset.rotated(-map.global_rotation))

func _enter_tree():
	Utils.current_level = self

func add_child(child, default=false):
	.add_child(child, default)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Utils.pause_mode = Node.PAUSE_MODE_PROCESS
	if !Utils.begun:
		Utils.begun = true
		var stream = AudioStreamPlayer.new()
		stream.stream = preload("res://sounds/music/ld49 (155 BPM 2021-10-03).wav")
		stream.bus = "Music"
		Utils.add_child(stream)
		Utils.player = stream
		stream.play()
	Utils.default_pickup_chance = 100
	change_level(0, level_size)
	$CanvasLayer/Retry.hide()
	$CanvasLayer/Overlay.hide()

func change_level(depth, size, effect=false):
	level_kills = 0
#	tween.interpolate_property(nav, "global_rotation", nav.global_rotation, Rng.range_f(deg2rad(-45), deg2rad(45)), 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#	tween.interpolate_property(player, "global_position", player.global_position, Vector2.ONE * level_size * 32 / 2, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
#	tween.start()
#	yield(tween, "tween_all_completed")
	if effect:
		get_tree().paused = true
		player.level_end_zoom_out()
		$Safe/AnimationPlayer.stop(true)
		$Safe/AnimationPlayer.play("transition")
		$Safe/Transition.play()
		yield(player, "level_end_zoom_out")
		get_tree().paused = false
	for child in get_children():
		if not child is PlayerObject and not child is Navigation2D and not child is CanvasLayer and not child.name == "Safe":
			child.queue_free()
	nav.global_rotation = Rng.range_f(deg2rad(-45), deg2rad(45))
	map.change_level(depth, level_size)
	map.set_tile(map.get_map_pos(map.get_world_pos(map.staircase_pos)), Map.Tile.Staircase)
	$CanvasLayer/PauseMenu/Floor/Label.text = str(depth + 1)
	$"CanvasLayer/Ur die/Floor/Label".text = str(depth + 1)


func explode_walls(pos):
	var dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO]
	var explode_distance = 24
	for dir in dirs:
		var cell_pos = map.get_map_pos(pos + dir * explode_distance)
		var cell = map.get_cellv(cell_pos)
		if cell == Map.Tile.Wall:
			map.set_tile(cell_pos, Map.Tile.Floor)
	pass

func _process(delta):
	crosshair.position = get_viewport().get_mouse_position()
	crosshair.rotation += delta * 10
	heart_display.texture.current_frame = min(player.hp, 12)
	if debug:
		if Input.is_action_just_pressed("debug_generate"):
			total_kills -= level_kills
			change_level(map.current_depth, level_size)#	
		if Input.is_action_just_pressed("debug_descend"):
			descend()		
		if Input.is_action_just_pressed("debug_zoom"):
			if player.camera.zoom.x == 1:
				player.camera.zoom *= 10
			else:
				player.camera.zoom /= 10
#	if Input.is_action_just_pressed("ui_cancel"):
#		if get_tree().paused:
#			unpause()
#		else:
#			pause()

func _on_Player_new_bullet(bullet):
	next_bullet_display.texture = bullet.hud_texture
	pass # Replace with function body.

func _on_TileMap_generated():
	player.global_position = (map.get_open_space() + Vector2(16, 16))
	populate()

func pause():
	$CanvasLayer/PauseMenu.show()
	$CanvasLayer.paused = true
	get_tree().paused = true
	pass

func unpause():
	$CanvasLayer.paused = false
	$CanvasLayer/PauseMenu.hide()
	get_tree().paused = false
	pass

func _on_Player_die():
	$Safe/AnimationPlayer.stop(true)
	$Safe/AnimationPlayer.play("die")
	dead = true
	pass # Replace with function body.


func _on_Retry_pressed():
	get_tree().reload_current_scene()


func _on_Player_hurt():
	if !player.dead:
		$Safe/AnimationPlayer.stop(true)
		$Safe/AnimationPlayer.play("hurt")
	pass # Replace with function body.

func _on_Stuck_pressed():
	player.global_position = (map.get_world_pos(Vector2.ONE * level_size/2))
	$CanvasLayer/PauseMenu/Stuck.disabled = true
	pass # Replace with function body.


func _on_Quit_pressed():
	unpause()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://StartScreen.tscn")
	pass # Replace with function body.


func _on_Resume_pressed():
	unpause()
	pass # Replace with function body.


func _on_CheckBox_toggled(button_pressed):
	Utils.set_music(button_pressed)
	pass # Replace with function body.
