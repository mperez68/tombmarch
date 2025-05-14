class_name Armor extends Node

@export var armor_name: String
@export_range(0, 1, 0.05) var block_chance: float
#@export_range(0, 1, 1, "or_greater") var riposte_damage: int

func block() -> bool:
	return randf() < block_chance
