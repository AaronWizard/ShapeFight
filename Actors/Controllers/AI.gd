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
		assert(path[0] == get_actor().cell_position)
		assert(path[ path.size() - 1 ] == target.cell_position)

	if path.size() > 0:
		while target.on_cell(path[ path.size() - 1 ]):
			path.remove(path.size() - 1)

	if path.size() > 0:
		assert(path[0] == get_actor().cell_position)

		if get_map().actor_can_enter_cell(get_actor(), path[1] as Vector2,
				false):
			var did := Direction.get_closest_direction(
					get_actor().cell_position, path[1])

			result = MoveActionScene.instance() as MoveAction
			result.actor = get_actor()
			result.direction = did

	return result

func _get_path(target: Actor) -> Array:
	_pathfinder.rebuild()
	return _pathfinder.get_path(get_actor().cell_position, target.cell_position)