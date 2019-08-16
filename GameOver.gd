extends VBoxContainer

# warning-ignore:unused_class_variable
export(String, FILE, '*.tscn') var main_menu_scene

func _on_Reload_pressed() -> void:
	pass # Replace with function body.

func _on_MainMenu_pressed() -> void:
	assert(get_tree().change_scene(main_menu_scene) == OK)

func _on_Quit_pressed() -> void:
	get_tree().quit()