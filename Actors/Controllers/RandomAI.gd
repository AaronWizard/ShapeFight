extends ActorController

class_name RandomAI

const MoveActionScene := preload('res://Actors/Actions/MoveAction.tscn')

onready var randomizer := RandomNumberGenerator.new()

func get_action() -> void:
	var result: ActorAction = null

	var valid_directions := []
	for did in Direction.ALL_DIRECTIONS:
		var direction: Vector2 = Direction.VECTORS[did]
		var new_cell := get_actor().cell_position + direction
		if get_map().actor_can_enter_cell(get_actor(), new_cell):
			valid_directions.append(did)

	if not valid_directions.empty():
		randomizer.randomize()
		var direction_index := randomizer.randi_range(
				0, valid_directions.size() - 1)
		var direction_id = valid_directions[direction_index]

		var action := MoveActionScene.instance() as MoveAction
		action.actor = get_actor()
		action.direction = direction_id

		result = action

	emit_signal('got_action', result)