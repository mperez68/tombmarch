extends Node

# group inventory
@export var inventory: Array[Resource]

func take(items_in: Array[Resource]):
	inventory.append_array(items_in)
