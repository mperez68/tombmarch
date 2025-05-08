class_name Controller extends CanvasLayer

enum Actions{ ATTACK, CAST, ITEM, RUN }

signal action_pressed(action: Actions)


# Events
func _on_action_button_pressed(action: Actions) -> void:
	action_pressed.emit(action)
