extends ActorAction

class_name MoveAction

const DURATION := 0.10
const TRANSITION_TYPE := Tween.TRANS_EXPO
const EASE_TYPE := Tween.EASE_OUT

onready var tween := $Tween as Tween

var direction: int

func get_is_concurrent() -> bool:
	return true

func run() -> void:
	var new_position: Vector2 = \
			actor.cell_position + Direction.VECTORS[direction]

	assert(get_map().actor_can_enter_cell(actor, new_position, false))

	var old_position := actor.cell_position
	actor.cell_position = new_position

	var offset = old_position - new_position
	actor.cell_offset = offset

	#warning-ignore:return_value_discarded
	tween.interpolate_property( \
			actor, 'cell_offset', offset, Vector2(),
			DURATION, TRANSITION_TYPE, EASE_TYPE)
	#warning-ignore:return_value_discarded
	tween.start()
	yield(tween, 'tween_completed')
	actor.cell_offset = Vector2()

	emit_signal('finished')