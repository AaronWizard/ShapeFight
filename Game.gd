extends Node

onready var stamina := $GUI/Stamina as Range

onready var map := $MapContainer/Map as Map
onready var overlay := $MapContainer/PathOverlay
onready var turn_processor := $TurnProcessor as TurnProcessor

onready var hero := $MapContainer/Map/Hero as Actor

func _ready() -> void:
	stamina.max_value = hero.stats.stamina

	_set_actor_events()
	turn_processor.run(map)

func _set_actor_events() -> void:
	for a in map.get_actors():
		var actor := a as Actor
		#warning-ignore:return_value_discarded
		actor.connect('died', self, '_actor_died', [actor])

func _on_Hero_took_damage(damage: int) -> void:
	stamina.value -= damage

func _actor_died(actor: Actor) -> void:
	map.remove_child(actor)
	if actor == hero:
		turn_processor.running = false

func _on_Hero_turn_started() -> void:
	overlay.actor = hero
	# warning-ignore:return_value_discarded
	overlay.connect('clicked_for_path', hero.controller, 'receive_walk_path')

func _on_Hero_turn_ended() -> void:
	overlay.actor = null
	overlay.disconnect('clicked_for_path', hero.controller, 'receive_walk_path')