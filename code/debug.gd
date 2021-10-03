extends Node

var enabled = true

var items = {
}

var times = {
}

var dbg_function

func dbg_enabled(id, value):
	items[id] = value

func dbg_disabled(_id, _value):
	pass

class Time:
	var length
	var name
	func _init(name, length):
		self.name = name
		self.length = length / 1000.0
		pass

func time_function(object: Object, method: String, args: Array):
	var start = OS.get_ticks_usec()
	object.callv(method, args)
	var end = OS.get_ticks_usec()
	if times.has(method):
		times[method].append(Time.new(method, end - start))
	else:
		times[method] = [Time.new(method, end - start)]

func _enter_tree():
	if enabled:
		dbg_function = funcref(self, "dbg_enabled")
	else:
		dbg_function = funcref(self, "dbg_disabled")

func _process(delta):
#	yield(get_tree(), "idle_frame")
	for time_array in times:
		var total_time = 0
		var counter = 0
		for time in times[time_array]:
			counter += 1
			total_time += time.length
		dbg(time_array, total_time)
		dbg(time_array + " avg", total_time / float(counter))
		dbg_max(time_array + " max", total_time)
#		times.erase(time_array)

func dbg(id, value):
	dbg_function.call_func(id, value)

func dbg_count(id, value, min_=1):
	if value >= min_:
		dbg(id, value)

func dbg_remove(id):
	items.erase(id)

func dbg_max(id, value):
	if !items.has(id) or items[id] < value:
		dbg(id, value)

func lines() -> Array:
	var lines = []
	for id in items:
		lines.append(str(id) + ": " + str(items[id]))	
	return lines
