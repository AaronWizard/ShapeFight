class_name Pathfinder

var _astar := AStar.new()

var map: Map
var actor: Actor

func rebuild() -> void:
	_astar.clear()

	_add_traversable_cells()
	_connect_traversable_cells()

func has_cell(cell: Vector2) -> bool:
	var id := _id_from_cell(cell.x, cell.y)
	return _astar.has_point(id)

func get_path(start: Vector2, end: Vector2) -> Array:
	var result := []

	#warning-ignore:narrowing_conversion
	#warning-ignore:narrowing_conversion
	var start_id := _id_from_cell(start.x, start.y)
	#warning-ignore:narrowing_conversion
	#warning-ignore:narrowing_conversion
	var end_id := _id_from_cell(end.x, end.y)

	var path := _astar.get_point_path(start_id, end_id)
	for pos in path:
		var cell := Vector2(pos.x, pos.y)
		result.append(cell)

	return result

func _add_traversable_cells():
	var rect := map.get_used_rect()

	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			var cell := Vector2(x, y)
			if map.actor_can_enter_cell(actor, cell, false):
				var id := _id_from_cell(x, y)
				_astar.add_point(id, Vector3(x, y, 0))

func _connect_traversable_cells():
	var cell_ids = _astar.get_points()
	for id in cell_ids:
		var cell := _cell_from_id(id)

		for did in Direction.ALL_DIRECTIONS:
			var direction: Vector2 = Direction.VECTORS[did]
			var adj_cell := cell + direction
			#warning-ignore:narrowing_conversion
			#warning-ignore:narrowing_conversion
			var adj_id := _id_from_cell(adj_cell.x, adj_cell.y)
			if _astar.has_point(adj_id) \
					and not _astar.are_points_connected(id, adj_id):
				_astar.connect_points(id, adj_id)

func _id_from_cell(x: int, y: int) -> int:
	var width := int(map.get_used_rect().size.x)
	return x + (y * width)

func _cell_from_id(id: int) -> Vector2:
	var result := Vector2()

	var width := int(map.get_used_rect().size.x)

	#warning-ignore:integer_division
	result.y = id / width
	result.x = id % width

	return result