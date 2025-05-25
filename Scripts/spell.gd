class_name Spell extends Node 

@export var display_name: String = "SPELL"
@export_multiline var description: String = "..."
@export_range(1, 3, 1, "hide_slider") var level: int = 1
@export var values: Array[int]
@export var mana_cost: int = 3
@export_group("targetting")
@export_range(0, 3, 1, "hide_slider") var target_limit: int = 1
@export var target_enemies: bool = true
@export var target_allies: bool = false
@export var target_self: bool = false

func can_cast(_targets: Array[Creature]) -> bool:
	return false

func cast(targets: Array[Creature]) -> bool:
	if can_cast(targets):
		_cast(targets)
		return true
	return false

## Override for spell effects.
func _cast(_targets: Array[Creature]) -> void:
	pass
