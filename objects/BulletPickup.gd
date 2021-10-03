extends Pickup

var bullet = null
var current_depth
var types = []

func _ready():
	current_depth = Utils.current_level.map.current_depth
		
	add_bullet_at_depth(0, preload( "res://objects/Bullets/Mags/NinjaStar.tres"))
	add_bullet_at_depth(0, preload( "res://objects/Bullets/Mags/Flame.tres"))
	add_bullet_at_depth(0, preload( "res://objects/Bullets/Mags/ShotgunShell.tres"))
	add_bullet_at_depth(1, preload( "res://objects/Bullets/Mags/Bee.tres"))
	add_bullet_at_depth(1, preload( "res://objects/Bullets/Mags/Bomb.tres"))
	add_bullet_at_depth(1, preload( "res://objects/Bullets/Mags/BananaPeel.tres"))
	add_bullet_at_depth(2, preload( "res://objects/Bullets/Mags/Confetti.tres"))
	add_bullet_at_depth(2, preload( "res://objects/Bullets/Mags/GrapplingHook.tres"))
	bullet = Rng.random_choice(types)

func add_bullet_at_depth(depth, bullet):
	if current_depth >= depth:
		types.append(bullet)

func consumed_by(player: PlayerObject):
	if bullet in Utils.player_object.gun.bullet_types.values():
		$Sound.stream = null
		while bullet == Utils.player_object.gun.current_bullet:
			bullet = Rng.random_choice(Utils.player_object.gun.bullet_types.values())
	player.gun.pickup(bullet)
	pass
