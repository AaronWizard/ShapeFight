tool
extends EditorPlugin

var tile_object : TileObject
var mouse_moved : bool

func handles(object: Object) -> bool:
	return object is TileObject

func edit(object: Object) -> void:
	assert(object is TileObject)
	tile_object = object

func make_visible(visible: bool) -> void:
	if not tile_object:
		return
	if not visible:
		tile_object = null
	update_overlays()

func forward_canvas_gui_input(event: InputEvent) -> bool:
	if not tile_object or not tile_object.visible:
		return false

	if event.is_action_pressed("ui_left"):
		_step_move(Vector2(-1, 0))
		return true
	if event.is_action_pressed("ui_right"):
		_step_move(Vector2(1, 0))
		return true
	if event.is_action_pressed("ui_up"):
		_step_move(Vector2(0, -1))
		return true
	if event.is_action_pressed("ui_down"):
		_step_move(Vector2(0, 1))
		return true

	if (event is InputEventMouseButton) \
			and (event.button_index == BUTTON_LEFT) and mouse_moved \
			and not event.is_pressed():
		tile_object.snap_to_closest_cell()

	if event is InputEventMouseMotion:
		mouse_moved = true
	else:
		mouse_moved = false

	return false

func _step_move(change: Vector2):
	tile_object.cell_position += change

	var undo : UndoRedo = get_undo_redo()
	undo.create_action("Move TileObject")
	undo.add_do_property(tile_object, "cell_position", \
			tile_object.cell_position)
	undo.add_undo_property(tile_object, "cell_position", \
			tile_object.cell_position - change)
	undo.commit_action()