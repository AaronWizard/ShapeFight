extends ActorController

class_name RandomAI

func get_action() -> ActorAction:
	yield(get_tree(), "idle_frame")
	print(get_actor().name, ": AI")

	var action := ActorAction.new()
	action.actor = get_actor()
	return action