class_name Fireblast extends Spell

func can_cast(targets: Array[Creature]) -> bool:
	return targets.size() == 1 and targets[0] is EnemyCreature

func _cast(targets: Array[Creature]) -> void:
	targets[0].damage(values[0], Creature.Type.BURNING, true)
