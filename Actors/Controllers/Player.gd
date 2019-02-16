extends ActorController

class_name Player

const MoveActionScene := preload("res://Actors/Actions/MoveAction.tscn")

signal _input_processed(action)

func _ready() -> void:
	._ready()
	set_process_unhandled_input(false)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("move_north"):
		_try_move(Direction.NORTH)
	elif Input.is_action_pressed("move_east"):
		_try_move(Direction.EAST)
	elif Input.is_action_pressed("move_south"):
		_try_move(Direction.SOUTH)
	elif Input.is_action_pressed("move_west"):
		_try_move(Direction.WEST)
	elif Input.is_action_just_pressed("wait"):
		emit_signal("_input_processed", null)

func _try_move(direction: int):
	var new_cell : Vector2 = \
			get_actor().cell_position + Direction.VECTORS[direction]
	if get_map().actor_can_enter_cell(get_actor(), new_cell):
		var action := MoveActionScene.instance() as MoveAction
		action.actor = get_actor()
		action.direction = direction
		emit_signal("_input_processed", action)

func get_action() -> void:
	set_process_unhandled_input(true)
	var action : ActorAction = yield(self, "_input_processed")
	set_process_unhandled_input(false)

	emit_signal("got_action", action)