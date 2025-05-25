class_name Item extends Node

@export_multiline var description: String

# Public
## Do action of item on given targets. Does nothing if input arguments are invalid.
func use(args: Array = []) -> bool:
	if can_use(args):
		_use(args)
		return true
	else:
		print("cannot use")
		return false

## Override to determine if item is usable on given targets.
func can_use(_args: Array = []) -> bool:
	return false


# Private
## Override to determine what this item does with given arguments.
func _use(_args: Array = []) -> void:
	print("no action")
