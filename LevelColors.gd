extends Resource

class_name DepthColors

export(Color) var depth1_floors
export(Color) var depth1_walls

export(Color) var depth2_floors
export(Color) var depth2_walls

export(Color) var depth3_floors
export(Color) var depth3_walls

export(Color) var depth4_floors
export(Color) var depth4_walls

export(Color) var depth5_floors
export(Color) var depth5_walls

export(Color) var depth6_floors
export(Color) var depth6_walls

export(Color) var depth7_floors
export(Color) var depth7_walls

export(Color) var depth8_floors
export(Color) var depth8_walls

export(Color) var depth9_floors
export(Color) var depth9_walls

export(Color) var depth10_floors
export(Color) var depth10_walls

export(Color) var depth11_floors
export(Color) var depth11_walls

export(Color) var depth12_floors
export(Color) var depth12_walls




class Scheme:
	var flr: Color
	var wall: Color
	func _init(flr, wall):
		self.flr = flr
		self.wall = wall

func get_colors(level_depth):
	var walls = [
		depth1_walls,
		depth2_walls,
		depth3_walls,
		depth4_walls,
		depth5_walls,
		depth6_walls,
		depth7_walls,
		depth8_walls,
		depth9_walls,
		depth10_walls,
		depth11_walls,
		depth12_walls,
	]
	
	var floors = [
		depth1_floors,
		depth2_floors,
		depth3_floors,
		depth4_floors,
		depth5_floors,
		depth6_floors,
		depth7_floors,
		depth8_floors,
		depth9_floors,
		depth10_floors,
		depth11_floors,
		depth12_floors,
	]
	var id = wrapi(level_depth, 0, 12)
	return Scheme.new(floors[id], walls[id])
