extends ActorController

class_name RandomAI

func get_action() -> void:
	yield(get_tree(), "idle_frame")
	print(get_actor().name, ": AI")