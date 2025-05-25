class_name ItemInfo extends Resource

enum Items{ GOLD, POTION }

@export var type: Items
@export_range(1, 1, 1, "or_greater") var value: int

const ITEM_SCENES: Dictionary = {
	Items.GOLD: preload("res://Items/gold.tscn"),
	Items.POTION: preload("res://Items/potion.tscn")
}

const ITEM_DESC: Dictionary = {
	Items.GOLD: "We're Rich!\n\nFind a wandering merchant to trade for goods.",
	Items.POTION: "With or without pulp?\n\nRestores 10 HP."
}

func usable() -> bool:
	return type != Items.GOLD

func generate() -> Node:
	return ITEM_SCENES[type].instantiate()

func display_name() -> String:
	return Items.keys()[type]

func description() -> String:
	return ITEM_DESC[type]
