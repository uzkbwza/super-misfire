extends Navigation2D

onready var map = $Map

func path_to_node(node1, node2):
	var path = get_simple_path(node1.global_position.rotated(-rotation), node2.global_position.rotated(-rotation), false)
	var array = PoolVector2Array()
	for point in path:
		array.append(point.rotated(rotation))
	return array
