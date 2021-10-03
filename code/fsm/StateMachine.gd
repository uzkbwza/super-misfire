extends Node

class_name StateMachine

var states_stack = []
var states_map = {}
var state = null
var queued_state_change = null

var initialized = false

signal state_changed(states_stack)

var host

func _enter_tree():
	host = get_parent()

func init(st=null):
	# Must be called with array of states before anything.
	# The first state in the array is the starting state for the machine.
	var states_array = get_children()
	var state_name
	for new_state in states_array:
		if new_state is StateInterface:
			state_name = _format_state_name(new_state)
			states_map[state_name] = new_state
			new_state.connect("queue_state_change", self, "queue_state")
		else:
			print("Invalid state %s for node %s" % [new_state.get_name(), host.get_name()])
			new_state.queue_free()
	if st:
		_change_state(state)
	else:
		_change_state(_format_state_name(states_array[0]))
	initialized = true

func queue_state(new_state, old_state):
	if old_state.active:
		queued_state_change = new_state

func update(delta):
	var next_state_name = state.update(delta)
	if queued_state_change:
		_change_state(queued_state_change)
		queued_state_change = null
	if next_state_name:
		_change_state(next_state_name)

func deactivate():
	state.active = false
	state.exit()

func integrate(st):
	state.integrate(st)

func _change_state(state_name):
	# Sets current state value to input, exits & cleans up previous state, and enters new one.
	var next_state

	# Special case if keyword "previous" is passed. State machine returns to previous state.
	if state_name == "previous":
		states_stack.pop_front()
		next_state = states_stack[0]
	else:
		next_state = states_map[state_name]
	if state: # if there is a currently running state, exit it
		state.exit()
		state.active = false
		
	state = next_state
	state.state_name = _format_state_name(state)
	states_stack.push_front(state)
	state.active = true
	state.enter()
	emit_signal("state_changed", states_stack)

func _format_state_name(unformatted_state):
	# Formats state names to camelCase.
	var name_ = unformatted_state.state_name
	name_[0] = name_[0].to_lower()
	return(str(name_))
