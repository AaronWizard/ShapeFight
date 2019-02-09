extends Node

class_name ActorAction

var actor : Actor

func get_map() -> Map:
	return actor.get_map()

func run() -> void:
	yield(get_tree(), "idle_frame") # Is an asynchronous method
	print('ActorAction: Must implement run')