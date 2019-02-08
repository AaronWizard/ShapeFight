extends Node

class_name ActorController

func get_actor() -> Actor:
	return get_parent() as Actor

func _ready() -> void:
	if get_actor():
		get_actor().controller = self

func get_action() -> void:
	yield(get_tree(), "idle_frame") # Is an asynchronous method
	print(name, ': Must implement get_action')