extends Control

signal run_started()
signal quiited()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Signals

func _on_new_run_button_pressed() -> void:
	run_started.emit()


func _on_quit_button_pressed() -> void:
	quiited.emit()
