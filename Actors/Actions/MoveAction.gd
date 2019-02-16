extends ActorAction

class_name MoveAction

var direction : int

func run() -> void:
	var new_position : Vector2 = \
			actor.cell_position + Direction.VECTORS[direction]
	actor.cell_position = new_position
	emit_signal("finished")