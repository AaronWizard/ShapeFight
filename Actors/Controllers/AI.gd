extends ActorController

class_name AI

const MoveActionScene := preload('res://Actors/Actions/MoveAction.tscn')
const AttackActionScene := preload('res://Actors/Actions/AttackAction.tscn')

onready var _pathfinder := Pathfinder.new()

func _ready() -> void:
	._ready()

	_pathfinder.map = get_map()
	_pathfinder.actor = get_actor()

func get_action() -> void:
	var result: ActorAction = null

	var target := _find_target()
	if target != null:
		result = _get_attack_action(target)
		if not result:
			result = _get_move_action(target)

	emit_signal('got_action', result)

func _find_target() -> Actor:
	var result: Actor = null

	for a in get_map().get_actors():
		var actor := a as Actor
		if actor.faction != get_actor().faction:
			result = actor

	return result

func _get_attack_action(target: Actor) -> AttackAction:
	var result: AttackAction = null

	if get_actor().is_adjacent(target):
		result = AttackActionScene.instance() as AttackAction
		result.actor = get_actor()
		result.target = target

	return result

func _get_move_action(target: Actor) -> MoveAction:
	var result: MoveAction = null

	var path := _get_path(target)

	if path.size() > 0:
		while target.on_cell(path[ path.size() - 1 ]):
			path.remove(path.size() - 1)

	if path.size() > 0:
		assert(path[0] == get_actor().cell_position)

		if get_map().actor_can_enter_cell(get_actor(), path[1] as Vector2,
				false):
			var did := Direction.get_closest_direction_diff(
					get_actor().cell_position, path[1])

			result = MoveActionScene.instance() as MoveAction
			result.actor = get_actor()
			result.direction = did

	return result

func _get_path(target: Actor) -> Array:
	_pathfinder.rebuild()

	var result := []

	var ends := _get_path_ends(target)
	if ends.size() > 0:
		for c in ends:
			var path := _pathfinder.get_path(get_actor().cell_position, c)
			if not path.empty():
				result = path
				break

	return result

func _get_path_ends(target: Actor) -> Array:
	var result := []

	var target_rect := target.get_cell_rect()
	var adjacent_positions := get_actor().adjacent_cell_positions(target_rect)

	for a in adjacent_positions:
		var cell := a as Vector2
		if _pathfinder.has_cell(cell):
			result.append(cell)

	result.sort_custom(self, '_sort_end_positions')
	return result

func _sort_end_positions(a: Vector2, b: Vector2) -> bool:
	var a_dist := get_actor().cell_position.distance_squared_to(a)
	var b_dist := get_actor().cell_position.distance_squared_to(b)
	return a_dist < b_dist