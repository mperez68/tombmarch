class_name Heal extends Spell

func can_cast(targets: Array[Creature]) -> bool:
	return targets.size() == 1 and targets[0] is PlayerCreature


## Override for spell effects.
func _cast(targets: Array[Creature]) -> void:
	targets[0].heal(values[0])
