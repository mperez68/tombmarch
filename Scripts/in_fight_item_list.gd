extends ItemList

var usable_items: Array[ItemInfo]

# Engine
func _ready() -> void:
	PlayerController.change_actor.connect(hide)


# Public
func populate():
	usable_items.clear()
	size.x = 1
	size.y = 1
	for item in ItemManager.inventory:
		if item is ItemInfo and item.usable():
			usable_items.push_back(item)
			add_item(str(item.value, " ", item.display_name()), null, item.can_use([PlayerController.actor]))


# Signals
func _on_item_selected(index: int) -> void:
	if usable_items[index].use([PlayerController.actor]):
		PlayerController.actor.expend()
		PlayerController.change_state(PlayerController.Select.NO_ACTIVE)
		PlayerController.set_ui.emit(false)
		hide()
	else:
		deselect(index) # TODO feedback for failed item use
