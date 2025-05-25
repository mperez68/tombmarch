class_name Potion extends Item

var heal_value: int = 10

## Heals given target for 10 HP.
## args[0]: PlayerCreature or PlayerInfo
func _use(args: Array = []) -> void:
	args[0].hp = min(args[0].hp + heal_value, args[0].max_hp)

func can_use(args: Array = []) -> bool:
	if args[0] is PlayerCreature or args[0] is PlayerInfo:
		return args[0].hp < args[0].max_hp
	return false
