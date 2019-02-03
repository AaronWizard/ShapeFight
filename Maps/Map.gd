extends TileMap

class_name Map

func get_actors() -> Array:
	return get_children()

func get_actor_at_cell(cell: Vector2) -> Actor:
	var result : Actor = null

	for a in get_actors():
		var actor := a as Actor
		if cell in actor.get_occupied_cells():
			result = actor
			break

	return result