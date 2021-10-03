extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var paused = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel") and !get_parent().dead:
		if get_tree().paused:
			get_parent().unpause()
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else:
			get_parent().pause()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
