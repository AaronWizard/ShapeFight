extends Node

class_name ActorAction

signal finished

var actor: Actor

var concurrent: bool setget , get_is_concurrent

func get_map() -> Map:
	return actor.get_map()

func get_is_concurrent() -> bool:
	return false

func run() -> void:
	print('ActorAction: Must implement run')
	emit_signal('finished')