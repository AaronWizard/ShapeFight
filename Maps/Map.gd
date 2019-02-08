extends TileMap

class_name Map

func _ready() -> void:
	_set_actor_ais()

	for a in get_actors():
		var actor := a as Actor
		var controller := actor.controller as ActorController
		controller.get_action()

func _set_actor_ais() -> void:
	for a in get_actors():
		var actor := a as Actor
		if actor.controller == null:
			actor.controller = RandomAI.new()

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