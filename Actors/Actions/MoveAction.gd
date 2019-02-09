extends ActorAction

class_name MoveAction

var direction : int

func run() -> void:
	yield(get_tree(), "idle_frame") # Is an asynchronous method
	var new_position : Vector2 = \
			actor.cell_position + Direction.VECTORS[direction]
	actor.cell_position = new_position