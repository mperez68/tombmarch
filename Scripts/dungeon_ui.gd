class_name DungeonController extends CanvasLayer

signal menu_change(open: bool)

enum Buttons{ INVENTORY, PARTY, LEAVE }

@onready var sfx = $SfxManager
@onready var inventory = %Inventory
@onready var party = %Party


# Public
func activate_leave():
	%LeaveButton.show()


# Events
func _on_button_pressed(action: Buttons) -> void:
	sfx.play(sfx.Sfx.CLICK)
	match action:
		Buttons.INVENTORY:
			inventory.visible = !inventory.visible
			inventory.populate()
			party.visible = false
			menu_change.emit(inventory.visible)
		Buttons.PARTY:
			party.visible = !party.visible
			party.populate()
			inventory.visible = false
			menu_change.emit(party.visible)
		Buttons.LEAVE:
			SceneManager.end_dungeon()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
