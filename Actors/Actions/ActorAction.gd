extends Node

class_name ActorAction

signal finished

var actor : Actor

func get_map() -> Map:
	return actor.get_map()

func run() -> void:
	print('ActorAction: Must implement run')
	emit_signal("finished")