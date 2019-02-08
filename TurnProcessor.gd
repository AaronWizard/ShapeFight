extends Node

export(NodePath) var map_path
var _map: Map

var _actor_index : int

func _ready() -> void:
	_map = get_node(map_path) as Map
	_set_actor_ais()

	call_deferred("_run")

func _set_actor_ais() -> void:
	for a in _map.get_actors():
		var actor := a as Actor
		if actor.controller == null:
			actor.controller = RandomAI.new()

func _run() -> void:
	_actor_index = -1
	while true:
		var actor = _get_next_actor()
		var controller := actor.controller as ActorController

		var action: ActorAction = yield(controller.get_action(), "completed")
		action.run()

func _get_next_actor() -> Actor:
	_actor_index = (_actor_index + 1) % _map.get_actors().size()
	return _map.get_actors()[_actor_index]