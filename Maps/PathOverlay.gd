extends TileMap

enum TileIDs {
	END_NORTH, END_EAST, END_SOUTH, END_WEST,
	START_NORTH, START_EAST, START_SOUTH, START_WEST,
	VERTICAL, HORIZONTAL,
	TURN_SOUTH_AND_EAST, TURN_SOUTH_AND_WEST, TURN_NORTH_AND_WEST, TURN_NORTH_AND_EAST
}

onready var _pathfinder := Pathfinder.new()

var _current_cell = null

var actor: Actor setget set_current_actor

func set_current_actor(value: Actor) -> void:
	actor = value

	set_process_unhandled_input(actor != null)

	_current_cell = null

	if value:
		_pathfinder.actor = value
		_pathfinder.map = value.get_map() as Map
		_pathfinder.rebuild()

		var mouse := get_viewport().get_mouse_position()
		var cell := world_to_map(mouse)
		_start_draw_path(cell)
	else:
		_pathfinder.clear()
		clear()

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var coords: Vector2 = event.position
		var cell := world_to_map(coords)
		_start_draw_path(cell)

func _start_draw_path(cell: Vector2) -> void:
	if cell:
		if _current_cell != cell:
			_current_cell = cell
			clear()

			if (cell != actor.cell_position) and _pathfinder.has_cell(cell):
				_draw_path(cell)
	else:
		clear()
		_current_cell = null

func _draw_path(cell: Vector2) -> void:
	var path := _pathfinder.get_path(actor.cell_position, cell)
	if path.size() > 0:
		assert(path.size() >= 2)

		_draw_path_start(path[0], path[1])
		_draw_path_end(path[ path.size() - 1 ], path[ path.size() - 2] )

		for i in range(1, path.size() - 1):
			_draw_path_middle(path[i - 1], path[i], path[i + 1])

func _draw_path_start(start: Vector2, next: Vector2) -> void:
	var direction := Direction.get_closest_direction_diff(start, next)
	var tile: int

	match direction:
		Direction.NORTH:
			tile = TileIDs.START_NORTH
		Direction.EAST:
			tile = TileIDs.START_EAST
		Direction.SOUTH:
			tile = TileIDs.START_SOUTH
		Direction.WEST:
			tile = TileIDs.START_WEST

	set_cellv(start, tile)

func _draw_path_end(end: Vector2, prev: Vector2) -> void:
	var direction := Direction.get_closest_direction_diff(prev, end)
	var tile: int

	match direction:
		Direction.NORTH:
			tile = TileIDs.END_NORTH
		Direction.EAST:
			tile = TileIDs.END_EAST
		Direction.SOUTH:
			tile = TileIDs.END_SOUTH
		Direction.WEST:
			tile = TileIDs.END_WEST

	set_cellv(end, tile)

func _draw_path_middle(prev: Vector2, current: Vector2, next:Vector2) -> void:
	var direction_prev := Direction.get_closest_direction_diff(prev, current)
	var direction_next := Direction.get_closest_direction_diff(current, next)
	var tile: int

	match [direction_prev, direction_next]:
		[Direction.EAST, Direction.EAST], [Direction.WEST, Direction.WEST]:
			tile = TileIDs.HORIZONTAL
		[Direction.NORTH, Direction.NORTH], [Direction.SOUTH, Direction.SOUTH]:
			tile = TileIDs.VERTICAL
		[Direction.NORTH, Direction.EAST], [Direction.WEST, Direction.SOUTH]:
			tile = TileIDs.TURN_SOUTH_AND_EAST
		[Direction.NORTH, Direction.WEST], [Direction.EAST, Direction.SOUTH]:
			tile = TileIDs.TURN_SOUTH_AND_WEST
		[Direction.EAST, Direction.NORTH], [Direction.SOUTH, Direction.WEST]:
			tile = TileIDs.TURN_NORTH_AND_WEST
		[Direction.WEST, Direction.NORTH], [Direction.SOUTH, Direction.EAST]:
			tile = TileIDs.TURN_NORTH_AND_EAST
		_:
			tile = TileIDs.END_NORTH

	set_cellv(current, tile)