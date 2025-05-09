class_name Controller extends CanvasLayer

enum Actions{ ATTACK, CAST, ITEM, RUN }

signal action_pressed(action: Actions)

# Engine
func _ready() -> void:
	TargetController.set_ui.connect(_set_ui)

# Private
func _set_ui(is_vis: bool):
	%ActionsMenu.visible = is_vis

# Events
func _on_action_button_pressed(action: Actions) -> void:
	action_pressed.emit(action)
	
	match action:
		Actions.ATTACK:
			TargetController.change_state(TargetController.Select.TARGET, false, 1)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
