class_name MobInfo extends Resource

enum Mob{ GOBLIN, ORC, WARBOSS }

@export var type: Mob

const MOB_SCENES: Dictionary = {
	Mob.GOBLIN: preload("res://Creatures/goblin.tscn"),
	Mob.ORC: preload("res://Creatures/orc.tscn"),
	Mob.WARBOSS: preload("res://Creatures/warboss.tscn")
}

func generate() -> Node:
	var ret = MOB_SCENES[type].instantiate()
	ret.hp = ret.max_hp
	return ret
