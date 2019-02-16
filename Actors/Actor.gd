tool
extends TileObject

class_name Actor

onready var stats = $Stats as Stats

var controller = null setget set_controller # ActorController

func get_map(): # -> Map
	return get_parent()

func set_controller(value) -> void: # : ActorController
	if controller == value:
		return

	if controller:
		remove_child(controller)
		controller.free()
		controller = null

	if value.get_parent() != self:
		add_child(value)

	controller = value