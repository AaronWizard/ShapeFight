tool
extends TileObject

class_name Actor

signal took_damage(damage)
signal died

enum Faction { PLAYER, ENEMY }
#warning-ignore:unused_class_variable
export(Faction) var faction := Faction.ENEMY

#warning-ignore:unused_class_variable
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

func _on_Stats_took_damage(damage) -> void:
	emit_signal('took_damage', damage)

func die() -> void:
	emit_signal('died')