extends CharacterObject

class_name PlayerObject

onready var gun = $Gun
onready var input = $InputControl
onready var camera = $Camera2D
onready var invuln_timer = $InvulnTimer

var camera_dist = 50
var camera_move_speed = 0.005

signal new_bullet(bullet)

signal level_end_zoom_out()

func _enter_tree():
	Utils.player_object = self

func _ready():
	Utils.current_camera = camera

func _physics_process(delta):
	if !invuln_timer.is_stopped():
		visible = !visible
	else:
		visible = true

func level_end_zoom_out():
	$Tween.interpolate_property(camera, "zoom", Vector2.ONE, Vector2(1.25, 1.25), 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	emit_signal("level_end_zoom_out")
	camera.zoom = Vector2.ONE

func angle_gun():
	aim_position = input.mouse_position
	gun.look_at(aim_position)
	gun.flip_v = Utils.ang2vec(gun.rotation).x < 0
	gun.z_index = -1 if gun.flip_v else 1
	
func shoot(blank=false):
	if dead:
		return
	if !blank:
		gun.shoot()
	else:
		gun.shoot_blank()
		
func move_camera(delta):
	camera.global_position = lerp(global_position, input.mouse_position, 0.3)

func hit_by(hitter, knockback=null):
	if hitter is StatusEffect:
		if hitter.host.dead:
			return
	.hit_by(hitter, knockback)
	if hitter.damage:
		Utils.screenshake(0.25)
		can_be_damaged = false
		$InvulnTimer.start()

func _on_InvulnTimer_timeout():
	can_be_damaged = true
	pass # Replace with function body.


func _on_Sprite_frame_changed():
	if sprite.animation == "walk" and sprite.frame == 1:
		Utils.play_sound_in_level($Footstep)
	pass # Replace with function body.
