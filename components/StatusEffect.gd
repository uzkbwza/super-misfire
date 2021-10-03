extends Node2D

class_name StatusEffect

onready var host = get_parent()
export var lifetime = 6

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	$LifetimeTimer.start(lifetime)
	host.status_effects[get_name()] = self
	begin()

func exit():
	host.status_effects.erase(get_name())
	queue_free()

func begin():
	pass

func _on_LifetimeTimer_timeout():
	exit()
	pass # Replace with function body.
