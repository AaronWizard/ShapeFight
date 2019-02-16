extends Node

signal _actions_finished

export var map_path: NodePath
var _map: Map

var _actor_index: int

func _ready() -> void:
	_map = get_node(map_path) as Map
	_set_actor_ais()

	call_deferred('_run')

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

		if (get_child_count() > 0) and ((controller is Player) \
				or _actor_has_action_running(actor)):
			yield(self, '_actions_finished')

		controller.call_deferred('get_action')
		var action: ActorAction = yield(controller, 'got_action')

		if action:
			if action.concurrent:
				add_child(action)
				action.connect('finished', self, '_action_finished', [action])

				action.call_deferred('run')
			else:
				if get_child_count() > 0:
					# Wait for other actions to finish
					yield(self, '_actions_finished')

				add_child(action)

				action.call_deferred('run')
				yield(action, 'finished')

				remove_child(action)
				action.queue_free()

func _get_next_actor() -> Actor:
	_actor_index = (_actor_index + 1) % _map.get_actors().size()
	return _map.get_actors()[_actor_index]

func _actor_has_action_running(actor: Actor) -> bool:
	var result := false

	for c in get_children():
		var action := c as ActorAction
		if action.actor == actor:
			result = true
			break

	return result

func _action_finished(action: ActorAction) -> void:
	remove_child(action)
	action.queue_free()

	if get_child_count() == 0:
		emit_signal('_actions_finished')