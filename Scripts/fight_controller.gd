class_name FightController extends CanvasLayer

enum Actions{ ATTACK, SPELL, ITEM, RUN }

@onready var sfx = $SfxManager
@onready var item_selector = %ItemList
@onready var spell_selector = %SpellList

signal action_pressed(action: Actions)
signal run

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
	spell_selector.clear()
	spell_selector.hide()
	match action:
		Actions.ATTACK:
			PlayerController.change_state(PlayerController.Select.TARGET, false, 1)
		Actions.SPELL:
			spell_selector.populate()
			spell_selector.show()
		Actions.ITEM:
			item_selector.populate()
			item_selector.show()
		Actions.RUN:
			if PlayerController.run():
				SceneManager.fight_success = false
				run.emit()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
