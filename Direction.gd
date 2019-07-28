class_name Direction

enum {NORTH, SOUTH, EAST, WEST}
const ALL_DIRECTIONS = [NORTH, SOUTH, EAST, WEST]

const VECTOR_NORTH := Vector2(0, -1)
const VECTOR_EAST := Vector2(1, 0)
const VECTOR_SOUTH := Vector2(0, 1)
const VECTOR_WEST := Vector2(-1, 0)

const VECTORS := {
	NORTH: VECTOR_NORTH,
	EAST: VECTOR_EAST,
	SOUTH: VECTOR_SOUTH,
	WEST: VECTOR_WEST,
}

static func get_closest_direction(value: Vector2) -> int:
	var result := NORTH
	var result_dotprod: float = VECTORS[result].dot(value)

	for direction in ALL_DIRECTIONS:
		var direction_vector := VECTORS[direction] as Vector2
		if direction_vector == value:
			result = direction
			break
		else:
			var dp := direction_vector.dot(value)
			if dp > result_dotprod:
				result = direction
				result_dotprod = dp

	return result

static func get_closest_direction_diff(start: Vector2, end: Vector2) -> int:
	return get_closest_direction(end - start)