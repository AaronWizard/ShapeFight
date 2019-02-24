extends Node

onready var map := $MapContainer/Map as Map
onready var turn_processor := $TurnProcessor as TurnProcessor

onready var hero := $MapContainer/Map/Hero as Actor

func _ready() -> void:
	_set_actor_events()
	turn_processor.run(map)

func _set_actor_events() -> void:
	for a in map.get_actors():
		var actor := a as Actor
		#warning-ignore:return_value_discarded
		actor.connect("died", self, '_actor_died', [actor])

func _actor_died(actor: Actor) -> void:
	map.remove_child(actor)
	if actor == hero:
		turn_processor.running = false