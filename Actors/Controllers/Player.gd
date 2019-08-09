extends ActorController

class_name Player

const MoveActionScene := preload('res://Actors/Actions/MoveAction.tscn')
const AttackActionScene := preload('res://Actors/Actions/AttackAction.tscn')

signal _input_processed(action)

var _taking_turn: bool

var _walk_path: Array
var _auto_steps: int

func _ready() -> void:
	._ready()
	_taking_turn = false
	_walk_path = []
	_auto_steps = 0

func _unhandled_input(event: InputEvent) -> void:
	_handle_keyboard_input()

	if event is InputEventMouseButton:
		_handle_mouse_input(event.position)

func _handle_keyboard_input() -> void:
	if _taking_turn:
		var is_waiting := false
		var action: ActorAction = null

		if Input.is_action_pressed('move_north'):
			action = _try_move(Direction.NORTH)
		elif Input.is_action_pressed('move_east'):
			action = _try_move(Direction.EAST)
		elif Input.is_action_pressed('move_south'):
			action = _try_move(Direction.SOUTH)
		elif Input.is_action_pressed('move_west'):
			action = _try_move(Direction.WEST)
		elif Input.is_action_just_pressed('wait'):
			is_waiting = true

		if action or is_waiting:
			emit_signal('_input_processed', action)
	elif _can_cancel_auto_walk():
		_cancel_auto_walk()

func _handle_mouse_input(click_position: Vector2) -> void:
	if Input.is_action_pressed("click"):
		if _taking_turn:
			_handle_click_attack(click_position)
		if _can_cancel_auto_walk():
			_cancel_auto_walk()

func _handle_click_attack(click_position: Vector2) -> void:
	var cell := get_map().world_to_map(click_position)

	var other_actor := get_map().get_actor_at_cell(cell)
	if (other_actor != null) and (other_actor != get_actor()) \
			and get_actor().is_adjacent(other_actor):
		var action := AttackActionScene.instance() as AttackAction
		action.actor = get_actor()
		action.target = other_actor
		emit_signal('_input_processed', action)

	if cell in get_actor().adjacent_cells():
		var action: = _try_attack(cell)
		if action:
			emit_signal('_input_processed', action)

func _can_cancel_auto_walk() -> bool:
	return (_walk_path.size() > 0) and (_auto_steps > 1)

func _cancel_auto_walk() -> void:
	_walk_path.clear()
	_auto_steps = 0

func receive_walk_path(path: Array) -> void:
	assert( is_processing_unhandled_input() )

	_auto_steps = 0

	_walk_path.clear()
	_walk_path += path # Make sure items in path are copied

	assert(_walk_path.front() == get_actor().cell_position)

	_walk_path.pop_front()

	if _taking_turn:
		var action := _try_walk_path()
		if action:
			emit_signal('_input_processed', action)

func _try_move(direction: int) -> ActorAction:
	var action: ActorAction = null

	var new_cell: Vector2 = \
			get_actor().cell_position + Direction.VECTORS[direction]
	if get_map().actor_can_enter_cell(get_actor(), new_cell, false):
		action = _create_move_action(direction)
	else:
		action = _try_attack(new_cell)

	return action

func _create_move_action(direction: int) -> ActorAction:
	var action := MoveActionScene.instance() as MoveAction
	action.actor = get_actor()
	action.direction = direction
	return action

func _try_attack(cell: Vector2) -> ActorAction:
	var action: ActorAction = null

	var other_actor := get_map().get_actor_at_cell(cell)
	if (other_actor != null) and (other_actor != get_actor()):
		action = AttackActionScene.instance() as AttackAction
		action.actor = get_actor()
		action.target = other_actor

	return action

func _try_walk_path() -> ActorAction:
	var action: ActorAction = null

	if _walk_path.size() > 0:
		var cell = _walk_path.front()
		_walk_path.pop_front()

		if get_map().actor_can_enter_cell(get_actor(), cell, false):
			var direction := Direction.get_closest_direction_diff(
					get_actor().cell_position, cell)
			action = _create_move_action(direction)
			_auto_steps += 1
		else:
			_walk_path.clear()

		if _walk_path.size() == 0:
			_auto_steps = 0

	return action

func get_action() -> void:
	_taking_turn = true

	var action: ActorAction = null
	action = _try_walk_path()
	if not action:
		action = yield(self, '_input_processed')

	_taking_turn = false

	emit_signal('got_action', action)