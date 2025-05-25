class_name InventoryView extends Control

# Inventory list
@onready var inventory: ItemList = %InventoryList
@onready var counts: ItemList = %CountList

# Description box
@onready var i_title: Label = %ItemTitle
@onready var i_owner: Label = %ItemOwner
@onready var i_desc: Label = %ItemDescription

# Item actions
@onready var use_button: Button = %UseButton
@onready var equip_button: Button = %EquipButton
@onready var unequip_button: Button = %UnequipButton
@onready var sell_button: Button = %SellButton

# Engine
func _ready() -> void:
	# Clear debug text
	_clear()
	populate()


# Public
func populate():
	# Clear current
	inventory.clear()
	counts.clear()
	_clear()
	## Populate characters list
	for item in ItemManager.inventory:
		if item is ItemInfo:
			counts.add_item(str(item.value))
		else:
			counts.add_item(" ")
		inventory.add_item(item.display_name())


# Private
## Clears description box and disables all buttons.
func _clear():
	i_title.text = "-"
	i_owner.text = "-"
	i_desc.text = ""
	use_button.visible = false
	equip_button.visible = false
	unequip_button.visible = false
	sell_button.visible = false


# Signals
func _on_use_button_pressed() -> void:
	pass # Replace with function body.

func _on_equip_button_pressed(equip: bool) -> void:
	pass # Replace with function body.

func _on_sell_button_pressed() -> void:
	pass # Replace with function body.

func _on_inventory_list_item_selected(index: int) -> void:
	_clear()
	counts.select(index)
	var item = ItemManager.inventory[index]
	i_title.text = item.display_name()
	if (item is WeaponInfo or item is ArmorInfo) and is_instance_valid(item.item_owner):
		i_owner.text = item.item_owner.display_name
	i_desc.text = item.description()
	if item is ItemInfo:
		use_button.visible = item.usable()
	else:
		equip_button.visible = true
		if is_instance_valid(item.item_owner):
			unequip_button.visible = true
