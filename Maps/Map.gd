extends TileMap

class_name Map

export var tile_properties_scene: PackedScene
onready var tile_properties_set: TilePropertiesSet \
		= tile_properties_scene.instance()

func is_valid_cell(cell: Vector2) -> bool:
	return get_cellv(cell) != INVALID_CELL

func get_actors() -> Array:
	return get_children()

func get_actor_at_cell(cell: Vector2) -> Actor:
	var result: Actor = null

	for a in get_actors():
		var actor := a as Actor
		if cell in actor.get_occupied_cells():
			result = actor
			break

	return result

func actor_can_enter_cell(actor: Actor, cell: Vector2) -> bool:
	var occupied_cells := actor.get_occupied_cell_at(cell)
	for occ_cell in occupied_cells:
		if not is_valid_cell(occ_cell):
			return false

		var tile_name := tile_set.tile_get_name(get_cellv(occ_cell))
		var tile_properties := tile_properties_set.get_properties(tile_name)
		if tile_properties and tile_properties.blocks_move:
			return false

		var other_actor := get_actor_at_cell(occ_cell)
		if (other_actor != null) and (other_actor != actor):
			return false

	return true