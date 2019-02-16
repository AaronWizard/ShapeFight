extends Node

class_name ActorController

signal got_action(action)

func get_actor() -> Actor:
	return get_parent() as Actor

func get_map() -> Map:
	return get_actor().get_map()

func _ready() -> void:
	if get_actor():
		get_actor().controller = self

func get_action() -> void:
	print('ActorController: Must implement get_action')
	emit_signal('got_action', null)