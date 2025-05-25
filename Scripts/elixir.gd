extends Item

var restore_value = 3

# Public
## Override to determine if item is usable on given targets.
func can_use(args: Array = []) -> bool:
	if args[0] is PlayerCreature or args[0] is PlayerInfo:
		return args[0].mp < args[0].max_mp
	return false


# Private
## Override to determine what this item does with given arguments.
func _use(args: Array = []) -> void:
	if args[0] is PlayerCreature:
		args[0].restore(restore_value)
	else:
		args[0].mp = min(args[0].mp + restore_value, args[0].max_mp)
