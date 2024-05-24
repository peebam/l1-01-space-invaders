extends Control

signal main_menu()


func _on_main_menu_button_pressed() -> void:
	main_menu.emit()
