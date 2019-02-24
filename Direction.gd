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

static func get_closest_direction(start: Vector2, end: Vector2) -> int:
	var diff := end - start

	var result := NORTH
	var dotprod: float = VECTORS[result].dot(diff)

	for did in ALL_DIRECTIONS:
		var direction := VECTORS[did] as Vector2
		var dp := direction.dot(diff)
		if dp > dotprod:
			result = did
			dotprod = dp

	return result