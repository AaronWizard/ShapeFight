extends ActorController

class_name RandomAI

onready var randomizer := RandomNumberGenerator.new()

func get_action() -> ActorAction:
	yield(get_tree(), "idle_frame")

	var valid_directions := []
	for did in Direction.ALL_DIRECTIONS:
		var direction : Vector2 = Direction.VECTORS[did]
		var new_cell := get_actor().cell_position + direction
		if get_map().actor_can_enter_cell(get_actor(), new_cell):
			valid_directions.append(did)

	randomizer.randomize()
	var direction_index := randomizer.randi_range(
			0, valid_directions.size() - 1)
	var direction_id = valid_directions[direction_index]

	var action := MoveAction.new()
	action.actor = get_actor()
	action.direction = direction_id

	return action