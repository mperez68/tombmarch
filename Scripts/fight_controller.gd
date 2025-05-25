class_name FightController extends CanvasLayer

enum Actions{ ATTACK, CAST, ITEM, RUN }

@onready var sfx = $SfxManager
@onready var item_selector = %ItemList

signal action_pressed(action: Actions)

# Engine
func _ready() -> void:
	PlayerController.set_ui.connect(_set_ui)

# Private
func _set_ui(is_vis: bool):
	%ActionsMenu.visible = is_vis

# Events
func _on_action_button_pressed(action: Actions) -> void:
	action_pressed.emit(action)
	sfx.play(sfx.Sfx.CLICK)
	item_selector.clear()
	item_selector.hide()
	match action:
		Actions.ATTACK:
			PlayerController.change_state(PlayerController.Select.TARGET, false, 1)
		Actions.ITEM:
			item_selector.populate()
			item_selector.show()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
