extends Node

class_name TurnProcessor

signal _actions_finished

var running := false

var _map: Map
var _actor_index: int

func run(map: Map) -> void:
	_map = map
	_actor_index = -1
	running = true

	while running:
		var actor = _get_next_actor()

		if not actor.controller:
			continue

		var controller := actor.controller as ActorController

		if (get_child_count() > 0) and ((controller is Player) \
				or _actor_has_action_running(actor)):
			yield(self, '_actions_finished')

		controller.call_deferred('get_action')
		var action: ActorAction = yield(controller, 'got_action')

		if action:
			if action.concurrent:
				add_child(action)
				#warning-ignore:return_value_discarded
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