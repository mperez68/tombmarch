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
## Experience towards next level.
@export_range(0, 100000, 0.1) var experience: int
@export_group("Stat Overrides")
@export_range(0, Creature.MAX_STAT, 1, "hide_slider") var strength: int
@export_range(0, Creature.MAX_STAT, 1, "hide_slider") var agility: int
@export_range(0, Creature.MAX_STAT, 1, "hide_slider") var intelligence: int
@export_group("Equipment")
@export var equipped_weapon: WeaponInfo
@export var equipped_armor: ArmorInfo

var initialized: bool = false
var hp: int
var max_hp: int
var mp: int
var max_mp: int
var inventory: Array[ItemInfo]


# Public
func generate() -> Node:
	var ret: PlayerCreature = PLAYER_SCENES[player_class].instantiate()
	# Initial data set
	if initialized:
		ret.hp = hp
		ret.mp = mp
		ret.strength = strength
		ret.agility = agility
		ret.intelligence = intelligence
	else:
		ret.hp = ret.max_hp
		max_hp = ret.max_hp
		ret.mp = ret.max_mp
		max_mp = ret.max_mp
		if strength != 0 or agility != 0 or intelligence != 0:
			ret.strength = strength
			ret.agility = agility
			ret.intelligence = intelligence
	# Equipment
	if is_instance_valid(equipped_weapon):
		ret.weapon = equipped_weapon.retrieve()
	if is_instance_valid(equipped_armor):
		ret.armor = equipped_armor.retrieve()
	return ret

func save(player: PlayerCreature) -> void:
	initialized = true
	hp = player.hp
	mp = player.mp
