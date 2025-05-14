class_name PlayerInfo extends Resource

enum PlayerClass{ FIGHTER, ARCHER, WIZARD }

const PLAYER_SCENES: Dictionary = {
	PlayerClass.FIGHTER: preload("res://Creatures/fighter.tscn"),
	PlayerClass.ARCHER: preload("res://Creatures/archer.tscn"),
	PlayerClass.WIZARD: preload("res://Creatures/wizard.tscn")
}

@export var display_name: String
@export var player_class: PlayerClass
@export_range(1, 1, 1.0, "or_greater") var experience_level: int
@export var equipped_weapon: WeaponInfo
@export var equipped_armor: ArmorInfo

var initialized: bool = false
var hp: int
var inventory: Array[ItemInfo]


# Public
func generate() -> Node:
	var ret: PlayerCreature = PLAYER_SCENES[player_class].instantiate()
	# Initial data set
	if initialized:
		ret.hp = hp
	else:
		ret.hp = ret.max_hp
	# Equipment
	if is_instance_valid(equipped_weapon):
		ret.weapon = equipped_weapon.generate()
		ret.add_child(ret.weapon)
	if is_instance_valid(equipped_armor):
		ret.armor = equipped_armor.generate()
		ret.add_child(ret.armor)
	return ret

func save(player: PlayerCreature) -> void:
	initialized = true
	hp = player.hp
