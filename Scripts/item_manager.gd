extends Node

enum Weapons{ BOW, MACE, STAFF }

@onready var all_weapons: Dictionary = {
	Weapons.BOW: $Bow,
	Weapons.MACE: $Mace,
	Weapons.STAFF: $Staff
}
