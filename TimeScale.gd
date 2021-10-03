extends Node

var scale = 1
var default_freeze_scale = 0.16
var slomo_scale = 0.25
var freeze_scale = default_freeze_scale
var freeze_frames = 0
var slomo_frames = 0
var overridden = false
var frozen = false
var debug_frozen = false
var slomo = false

signal freeze_ended()
signal player_hit_freeze()

func set_to(scale: float, debug=false):
	if !debug_frozen or debug:
		self.scale = scale
		apply()

func reset(debug=false):
	if !debug_frozen or debug:
		scale = 1
		freeze_frames = 0
		overridden = false
		frozen = false
		slomo = false
		apply()
		
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta):
	if get_tree().paused:
		reset()
	if slomo:
		Debug.dbg("slomo frames", slomo_frames)
		slomo_frames -= delta / scale
		if slomo_frames <= 0:
			slomo(false)
			reset()
	else:
		if freeze_frames > 0 or debug_frozen:
			frozen = true
			freeze_frames -= delta / scale	
			set_to(freeze_scale)
			if freeze_frames <= 0:
				reset()
				emit_signal("freeze_ended")
#	if Input.is_action_just_pressed("debug_slomo") and Debug.enabled:
#		slomo(true, 1)

func apply():
	Engine.time_scale = scale

func freeze(seconds: float, scale=default_freeze_scale):
#	print(seconds)
	if !overridden:
		if seconds > freeze_frames: freeze_frames = seconds
		freeze_scale = scale
		frozen = true

func slomo(on=true, time=0.0):
	if on:	
		if time > slomo_frames:
			slomo_frames = time
			slomo = true
			set_to(slomo_scale)
	else:
		slomo = false
		slomo_frames = 0
		set_to(1)

func freeze_override(seconds: float, scale=default_freeze_scale):
	# force freeze frames for the entire duration, ignoring 
	freeze_frames = seconds
	freeze_scale = scale
	overridden = true
	frozen = true
