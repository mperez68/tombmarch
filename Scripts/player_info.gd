class_name PlayerInfo extends Resource

enum PlayerClass{ FIGHTER, ARCHER, WIZARD }

const PLAYER_SCENES: Dictionary = {
	PlayerClass.FIGHTER: preload("res://Creatures/fighter.tscn"),
	PlayerClass.ARCHER: preload("res://Creatures/archer.tscn"),
	PlayerClass.WIZARD: preload("res://Creatures/wizard.tscn")
}

@export var display_name: String
@export var player_class: PlayerClass
@export_range(1, 1, 1.0, "or_greater") var experience: int

var initialized: bool = false
var hp: int
var inventory: Array[ItemInfo]
var equipped_weapon: ItemInfo


# Public
func generate() -> Node:
	var ret = PLAYER_SCENES[player_class].instantiate()
	if initialized:
		ret.hp = hp
	else:
		ret.hp = ret.max_hp
	return ret

func save(player: PlayerCreature) -> void:
	initialized = true
	hp = player.hp
