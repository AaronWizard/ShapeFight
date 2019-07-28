extends TileMap

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

			if _pathfinder.has_cell(cell):
				_draw_path(cell)
	else:
		clear()
		_current_cell = null

func _draw_path(cell: Vector2) -> void:
	var path := _pathfinder.get_path(actor.cell_position, cell)
	for c in path:
		set_cellv(c, 1)