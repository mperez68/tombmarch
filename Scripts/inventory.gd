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
@onready var player_select: PopupMenu = %PlayerItemSelect
@onready var all_player_select: PopupMenu = %AllPlayersSelect

var selected_item: Resource
var player_select_options: Array = []

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
	all_player_select.clear()
	all_player_select.size.x = 1
	all_player_select.size.y = 1
	for player in PlayerManager.players:
		all_player_select.add_item(player.display_name)

func remove(res: Resource):
	ItemManager.remove(ItemManager.inventory.find(res))

# Private
## Clears description box and disables all buttons.
func _clear():
	selected_item = null
	player_select_options.clear()
	i_title.text = "-"
	i_owner.text = "-"
	i_desc.text = ""
	use_button.visible = false
	use_button.disabled = false
	equip_button.visible = false
	unequip_button.visible = false
	sell_button.visible = false


# Signals
func _on_use_button_pressed() -> void:
	if selected_item is not ItemInfo:
		return
	player_select.clear()
	player_select.size.x = 1
	player_select.size.y = 1
	
	for player in PlayerManager.players:
		if selected_item.can_use([player]):
			player_select.add_item(player.display_name)
			player_select_options.push_back(player)
	player_select.show()

## Only used for using an item.
func _on_player_select_index_pressed(index: int) -> void:
	selected_item.use([player_select_options[index]])
	if selected_item.value <= 0:
		remove(selected_item)
	populate()

## Only used for equiping an item.
func _on_all_players_select_index_pressed(index: int) -> void:
	selected_item.equip(PlayerManager.players[index])
	populate()

func _on_equip_button_pressed(equip: bool) -> void:
	if selected_item is ItemInfo:
		return
	if equip:
		all_player_select.show()
	else:
		selected_item.unequip()
		populate()

func _on_sell_button_pressed() -> void:
	if selected_item is ItemInfo:
		return

func _on_inventory_list_item_selected(index: int) -> void:
	_clear()
	counts.select(index)
	selected_item = ItemManager.inventory[index]
	i_title.text = selected_item.display_name()
	if (selected_item is WeaponInfo or selected_item is ArmorInfo) and is_instance_valid(selected_item.item_owner):
		i_owner.text = selected_item.item_owner.display_name
	i_desc.text = selected_item.description()
	if selected_item is ItemInfo:
		use_button.visible = selected_item.usable()
		use_button.disabled = true
		for player in PlayerManager.players:
			if selected_item.can_use([player]):
				use_button.disabled = false
				break
	else:
		equip_button.visible = true
		if is_instance_valid(selected_item.item_owner):
			unequip_button.visible = true
