extends Node

# group inventory
@export var inventory: Array[InventoryInfo]

func take(items_in: Array[InventoryInfo]):
	var items: Array[InventoryInfo]
	var hit = false
	for item in items_in:
		hit = false
		for i_item in inventory:
			if item is ItemInfo and i_item is ItemInfo and item.type == i_item.type:
				i_item.value += item.value
				hit = true
				break
		if !hit:
			items.push_back(item)
	
	inventory.append_array(items)

func remove(index: int):
	inventory.remove_at(index)
