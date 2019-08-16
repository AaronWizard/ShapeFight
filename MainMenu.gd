extends VBoxContainer

# warning-ignore:unused_class_variable
export(String, FILE, '*.tscn') var game_scene

func _on_Start_pressed() -> void:
	assert(get_tree().change_scene(game_scene) == OK)

func _on_Load_pressed() -> void:
	pass # Replace with function body.

func _on_Options_pressed() -> void:
	pass # Replace with function body.

func _on_Quit_pressed() -> void:
	get_tree().quit()