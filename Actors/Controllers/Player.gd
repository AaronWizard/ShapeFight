extends ActorController

class_name Player

const MoveActionScene := preload('res://Actors/Actions/MoveAction.tscn')
const AttackActionScene := preload('res://Actors/Actions/AttackAction.tscn')

signal _input_processed(action)

var _walk_path: Array

func _ready() -> void:
	._ready()
	set_process_unhandled_input(false)
	_walk_path = []

func _unhandled_input(_event: InputEvent) -> void:
	var action: ActorAction = null
	var is_waiting := false

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

func receive_walk_path(path: Array) -> void:
	assert( is_processing_unhandled_input() )
	_walk_path.clear()
	_walk_path += path # Make sure items in path are copied
	assert(_walk_path.front() == get_actor().cell_position)
	_walk_path.pop_front()

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
		else:
			_walk_path.clear()

	return action

func get_action() -> void:
	var action: ActorAction = null

	set_process_unhandled_input(true)

	action = _try_walk_path()
	if not action:
		action = yield(self, '_input_processed')

	set_process_unhandled_input(false)

	emit_signal('got_action', action)