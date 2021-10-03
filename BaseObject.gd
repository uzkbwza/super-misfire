extends KinematicObject2D

class_name BaseObject

onready var state_machine = $StateMachine
onready var sprite = get_node_or_null("Sprite")
export var can_be_damaged = false
export var max_hp = 2
onready var hp = max_hp
export var damage = 0.0
var dead = false
signal die()
signal hurt()

func add_hp(amount):
	hp = Utils.approach(hp, max_hp, amount)

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	state_machine.init()

func _physics_process(delta):
	state_machine.update(delta)

func hit_by(hitter, knockback=null):
	if !can_be_damaged or hitter.damage <= 0:
		return
	emit_signal("hurt")
	if knockback:
		apply_impulse(knockback * 10000)
	Utils.play_effect("Slash", (global_position + hitter.global_position) / 2)
	hp -= round(hitter.damage)
	if hp <= 0:
		hp = 0
		die()

func die():
	if !dead:
		emit_signal("die")
		dead = true

func rotate_forward():
	global_rotation = vel.angle()

func rotation_flip():
	sprite.flip_h = Utils.ang2vec(global_rotation).x < 0
