extends Node

# warning-ignore:unused_class_variable
export(String, FILE, '*.tscn') var game_over_scene

onready var game_over_transition := $Transitions/GameOverTransition

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

func _on_TurnProcessor_turn_started(actor) -> void:
	if actor == hero:
		overlay.actor = hero
		# warning-ignore:return_value_discarded
		overlay.connect('clicked_for_path', hero.controller, 'receive_walk_path')

func _on_TurnProcessor_turn_ended(actor) -> void:
	if actor == hero:
		overlay.actor = null
		overlay.disconnect('clicked_for_path', hero.controller, 'receive_walk_path')

func _on_Hero_took_damage(damage: int) -> void:
	stamina.value -= damage

func _actor_died(actor: Actor) -> void:
	map.remove_child(actor)
	if actor == hero:
		_game_over()

func _game_over() -> void:
	turn_processor.running = false

	game_over_transition.show()
	game_over_transition.play()
	yield(game_over_transition, 'animation_finished')

	assert(get_tree().change_scene(game_over_scene) == OK)