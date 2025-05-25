class_name ItemInfo extends Resource

enum Items{ GOLD, POTION }

@export var type: Items
@export_range(1, 1, 1, "or_greater") var value: int

const ITEM_SCENES: Dictionary = {
	Items.GOLD: preload("res://Items/gold.tscn"),
	Items.POTION: preload("res://Items/potion.tscn")
}

var ref_pointer: Item


# Public
func usable() -> bool:
	return type != Items.GOLD

func use(args: Array = []) -> bool:
	if usable() and retrieve().use(args):
		value -= 1
		return true
	return false

func can_use(args: Array = []) -> bool:
	return retrieve().can_use(args)

func generate() -> Node:
	return ITEM_SCENES[type].instantiate()

func retrieve() -> Item:
	if !is_instance_valid(ref_pointer):
		var ref = generate()
		ItemManager.add_child(ref)
		ref_pointer = ref

	return ref_pointer

func display_name() -> String:
	return Items.keys()[type]

func description() -> String:
	return retrieve().description
