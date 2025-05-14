extends Node

enum Weapons{ BOW, MACE, STAFF }

@onready var base_weapons: Dictionary = {
	Weapons.BOW: $Bow,
	Weapons.MACE: $Mace,
	Weapons.STAFF: $Staff
}
