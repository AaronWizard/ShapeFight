tool
extends TileObject

class_name Actor

var map setget , get_map # : Map
var controller = null setget set_controller # ActorController

func get_map(): # -> Map
	return get_parent()

func set_controller(value) -> void:
	if controller == value:
		return

	if controller:
		remove_child(controller)
		controller.free()
		controller = null

	if value.get_parent() != self:
		add_child(value)

	controller = value

func _ready() -> void:
	._ready()