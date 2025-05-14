class_name ItemInfo extends Resource

enum Items{ GOLD, POTION }

@export var type: Items
@export_range(1, 1, 1, "or_greater") var value: int

const ITEM_SCENES: Dictionary = {
	Items.GOLD: preload("res://Items/gold.tscn"),
	Items.POTION: preload("res://Items/potion.tscn")
}

func generate() -> Node:
	return ITEM_SCENES[type].instantiate()
