extends TileMap

class_name Map

export var walk_length = 70
export var walks = 5
export var edge_wall_size = 20
export var buffer = 30
export(Resource) var depth_colors
var current_depth = 0
var open = []
var player_start = Vector2()
var staircase_pos
#export var min_dist_to_exit = 40
export(Color) var hurt_floor_color
export(Color) var hurt_wall_color

var level_colors

func change_level(id, size):
	current_depth = id
	var colors = depth_colors.get_colors(id)
	get_material().set_shader_param("floor_color", colors.flr)
	get_material().set_shader_param("wall_color", colors.wall)
	level_colors = colors
	generate_level(size)

enum Tile {
	Wall = 0,
	Floor = 1,
	EdgeWall = 2,
	Staircase = 3,
}


func hurt_anim_start():
	get_material().set_shader_param("floor_color", hurt_floor_color)
	get_material().set_shader_param("wall_color", hurt_wall_color)
	pass
	
func hurt_anim_end():
	get_material().set_shader_param("floor_color", level_colors.flr)
	get_material().set_shader_param("wall_color", level_colors.wall)
	pass

signal generated()
	
func set_tile(pos, tile):
	if get_cellv(pos) != Tile.EdgeWall:
		set_cellv(pos, tile)
		return true
	return false

func dig_corridor(c1, c2, vertical, open_spaces=open):
		var min_x = min(c1.x, c2.x)
		var max_x = max(c1.x, c2.x)
		var min_y = min(c1.y, c2.y)
		var max_y = max(c1.y, c2.y)
		if vertical:
			for y in range(max_y - min_y):
				var pos = Vector2(max_x, min_y + y)
				if set_tile(pos, Tile.Floor):
					open_spaces.append(pos)
				
			for x in range(max_x - min_x):
				var pos = Vector2(max_x - x, max_y)
				if set_tile(pos, Tile.Floor):
					open_spaces.append(pos)
		else:
			for x in range(max_x - min_x):
				var pos = Vector2(min_x + x, max_y)
				if set_tile(pos, Tile.Floor):
					open_spaces.append(pos)
			for y in range(max_y - min_y):
				var pos = Vector2(min_x, max_y - y)
				if set_tile(pos, Tile.Floor):
					open_spaces.append(pos)

func generate_level(size):
	player_start = Vector2()
	staircase_pos = Vector2()
	clear()
	for x in range(-edge_wall_size/2 -buffer/2, size + edge_wall_size/2 + buffer/2):
		for y in range(-edge_wall_size/2 -buffer/2, size + edge_wall_size/2 + buffer/2):
			if !(Utils.is_in_range(x, 0, size) and Utils.is_in_range(y, 0, size)):
				set_cell(x, y, Tile.EdgeWall)
		
	for x in range(-buffer/2, size + buffer/2):
		for y in range(-buffer/2, size + buffer/2):
			if !(Utils.is_in_range(x, 0, size) and Utils.is_in_range(y, 0, size)):
				set_cell(x, y, Tile.Wall)
	

	for row in range(size):
		for col in range(size):
			set_cell(col, row, Tile.Wall)
			
	# drunken walk generation connected by corridors
	var open_spaces = [Vector2(size/2, size/2)]
	var corridor_points = [Vector2(size/2, size/2)]
	set_cellv(open_spaces[0], Tile.Floor)
	
	for i in range(walks):
		var pos = Vector2(Rng.range_i(0, size), Rng.range_i(0, size))
		dig_corridor(pos, open_spaces[-1], Rng.coin_flip(), open_spaces)
		corridor_points.append(pos)
		var counter = 0
		while counter < int(walk_length / walks):
			if get_cellv(pos) == Tile.Wall:
				set_cellv(pos, Tile.Floor)
				counter += 1
				open_spaces.append(pos)
			pos += Rng.random_grid_dir_cardinal()
#			yield(get_tree(), "physics_frame")
			pos.x = clamp(pos.x, 0, size)
			pos.y = clamp(pos.y, 0, size)
			
	for i in range(corridor_points.size()):
		var c1 = corridor_points[i]
		var c2 = corridor_points[i + 1] if i < corridor_points.size() - 1 else corridor_points[0]
		var vertical = Rng.coin_flip()
		dig_corridor(c1, c2, vertical, open_spaces)
	open_spaces = Utils.remove_duplicates(open_spaces)
	open.clear()
	open = open_spaces
	player_start = get_open_cell()
	open.erase(player_start)
	staircase_pos = get_furthest_cell_from(player_start)
	while staircase_pos == player_start:
		staircase_pos = get_open_cell()
	
#	while staircase_pos.distance_to(player_start) < 7:
#		staircase_pos = get_open_cell()
#	var farthest_pair = null
#	var farthest_dist = 0
#	var dist_sum = 0
#	for i in range(100):
#		var s = get_open_cell()
#		var p = get_open_cell()
#		var dist = s.distance_to(p)
#		dist_sum += dist
#		if dist > farthest_dist:
#			staircase_pos = s
#			player_start = p
#			farthest_dist = dist
#	var avg_dist = dist_sum / 100.0
	dig_corridor(player_start, Vector2(size/2, size/2), Rng.coin_flip(), open_spaces)
	dig_corridor(Vector2(size/2, size/2), staircase_pos, Rng.coin_flip(), open_spaces)
	Debug.dbg("player_start", player_start)
	Debug.dbg("staircase_pos", staircase_pos)
	Debug.dbg("staircase_distance", staircase_pos.distance_to(player_start))
	emit_signal("generated")

func get_furthest_cell_from(cell):
	var stack = []
	var filled = {}
	stack.push_back(cell)
	var n
	var counter = 0
	while stack.size():
		counter += 1
		n = stack.pop_front()
		if get_cellv(n) == Tile.Floor and !filled.has(n):
			filled[n] = counter
			stack.push_back(n + Vector2.LEFT)
			stack.push_back(n + Vector2.RIGHT)
			stack.push_back(n + Vector2.UP)
			stack.push_back(n + Vector2.DOWN)
	var cells = []
	for cell in filled.keys():
		cells.append([cell, filled[cell]])
	cells.sort_custom(self, "sort_cell_distances")
	return cells[0][0]
#	var farthest_dist = 0
#	var farthest = cell
#	for tile in get_used_cells():
#		if get_cellv(tile) == Tile.Floor:
#			var dist = tile.distance_squared_to(cell)
#			if dist > farthest_dist:
#				farthest_dist = dist
#				farthest = cell
#	return farthest

func sort_cell_distances(a, b):
	return a[1] > b[1]

func get_open_space():
	return get_world_pos(get_open_cell())

func get_open_cell():
	return Rng.random_choice(open)

func get_map_pos(pos):
	return world_to_map(pos.rotated(-global_rotation))

func get_world_pos(cell):
	return map_to_world(cell).rotated(global_rotation)

func get_cell_pos(node):
	return get_map_pos(node.global_position)
