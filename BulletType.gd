extends Resource

class_name BulletType

export(String) var name
export(PackedScene) var scene
export(float) var mag_size = 0
export(float) var shoot_speed = 0
export(int) var bullets_per_shot = 1
export(Texture) var hud_texture
export(bool) var muzzle_flash_all_shots = true
export(bool) var wait_till_exit = false
export var pushback_amount = 50
export(AudioStream) var sound
