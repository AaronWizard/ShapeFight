extends ActorController

class_name Player

signal _input_processed

func _ready() -> void:
	._ready()
	set_process_unhandled_input(false)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		_process_key_input(event)

func _process_key_input(event: InputEventKey) -> void:
	if event.pressed:
		emit_signal("_input_processed")

func get_action() -> void:
	print("press key to continue")

	set_process_unhandled_input(true)
	yield(self, "_input_processed")
	set_process_unhandled_input(false)

	print(get_actor().name, ": Player")