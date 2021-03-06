tool
extends Node2D

class_name TileObject

# Base size of cells in pixels.
export var cell_size: Vector2 = Vector2(16, 16) setget set_cell_size

# Position in cells. Origin is top-left.
export var cell_position: Vector2 = Vector2(0, 0) setget set_cell_position

# Diameter in cells.
export var cell_diameter: int = 1 setget set_cell_diameter

# Offset in cells. Origin is centre of tile object.
export var cell_offset: Vector2 = Vector2(0, 0) setget set_cell_offset

func _ready() -> void:
	var parent_map := get_parent() as TileMap
	if parent_map:
		set_cell_size(parent_map.cell_size)
	else:
		_recalculate_centre()

	if Engine.editor_hint:
		call_deferred('snap_to_closest_cell')

func set_cell_size(value: Vector2) -> void:
	cell_size = value
	_recalculate_position()
	_recalculate_centre()
	set_cell_offset(cell_offset)

func set_cell_position(value: Vector2) -> void:
	cell_position = value
	_recalculate_position()

func set_cell_diameter(value: int) -> void:
	cell_diameter = value
	_recalculate_centre()
	update()

func set_cell_offset(value: Vector2) -> void:
	if has_node('Centre/Offset'):
		cell_offset = value
		($Centre/Offset as Node2D).position = value * cell_size

func snap_to_closest_cell() -> void:
	var cell_pos := position / cell_size
	var true_cell_pos := Vector2(round(cell_pos.x), round(cell_pos.y))
	set_cell_position(true_cell_pos)

func _recalculate_position() -> void:
	position = cell_position * cell_size
	update()

func _recalculate_centre() -> void:
	if has_node('Centre'):
		($Centre as Node2D).position = (cell_size * cell_diameter) / 2.0

func _draw() -> void:
	if not Engine.editor_hint:
		return

	var size := cell_size * cell_diameter
	var rect := Rect2(Vector2(), size)
	draw_rect(rect, Color(1, 0, 1), false)

func get_occupied_cells_at(origin: Vector2 = Vector2()) -> Array:
	var result := []
	for x in range(cell_diameter):
		for y in range(cell_diameter):
			var cell := Vector2(x, y) + origin
			result.append(cell)
	return result

func get_occupied_cells() -> Array:
	return get_occupied_cells_at(cell_position)

func on_cell(cell: Vector2) -> bool:
	return cell in get_occupied_cells()

func adjacent_cells() -> Array:
	var result := []

	var cell: Vector2

	for index in range(cell_diameter):
		cell = Vector2(index, -1) # North edge
		result.append(cell + cell_position)

		cell = Vector2(cell_diameter, index) # East edge
		result.append(cell + cell_position)

		cell = Vector2(index, cell_diameter) # South edge
		result.append(cell + cell_position)

		cell = Vector2(-1, index) # West edge
		result.append(cell + cell_position)

	return result

func is_adjacent(other: TileObject) -> bool:
	var result := false

	for c in adjacent_cells():
		var cell := c as Vector2
		if other.on_cell(cell):
			result = true
			break

	return result

func get_cell_rect() -> Rect2:
	return Rect2(cell_position, Vector2(cell_diameter, cell_diameter))

func adjacent_cell_positions(cell_rect: Rect2) -> Array:
	var result := []

	var min_pos := cell_rect.position - Vector2(cell_diameter, cell_diameter)
	var max_pos := cell_rect.end + Vector2(1, 1)

	var cell: Vector2

	for x in range(min_pos.x + 1, max_pos.x - 1):
		# North side
		cell = Vector2(x, cell_rect.position.y - cell_diameter)
		result.append(cell)

		# South side
		cell = Vector2(x, cell_rect.position.y + cell_rect.size.y)
		result.append(cell)

	for y in range(min_pos.y + 1, max_pos.y - 1):
		# East side
		cell = Vector2(cell_rect.position.x + cell_rect.size.x, y)
		result.append(cell)

		# West side
		cell = Vector2(cell_rect.position.x - cell_diameter, y)
		result.append(cell)

	return result