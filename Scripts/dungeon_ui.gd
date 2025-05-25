class_name DungeonController extends CanvasLayer

signal menu_change(open: bool)

enum Buttons{ INVENTORY, PARTY }

@onready var sfx = $SfxManager


# Events
func _on_button_pressed(action: Buttons) -> void:
	sfx.play(sfx.Sfx.CLICK)
	match action:
		Buttons.INVENTORY:
			%Inventory.visible = !%Inventory.visible
			%Inventory.populate()
			%Party.visible = false
			menu_change.emit(%Inventory.visible)
		Buttons.PARTY:
			%Party.visible = !%Party.visible
			%Inventory.visible = false
			menu_change.emit(%Party.visible)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
