extends Node

class_name TilePropertiesSet

func get_properties(tile_name: String) -> TileProperties:
	var result: TileProperties = null

	for p in get_children():
		var properties := p as TileProperties
		if tile_name in properties.tile_names:
			result = properties
			break

	return result