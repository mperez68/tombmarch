class_name Weapon extends Node

@export var weapon_name: String
@export var primary_stat: Creature.Stats
@export var secondary_stat: Creature.Stats
@export_range(0,1) var hit_chance: float = 0.5
@export_range(0,1) var crit_chance: float = 0.2
@export_range(1, 999, 1, "or_greater") var crit_multiplier: float = 2.0
@export_group("Primary Damage")
@export var damage_type: Creature.Type
@export_range(0, 999, 1, "or_greater") var min_damage: int = 1
@export_range(0, 999, 1, "or_greater") var max_damage: int = 2
@export_group("Secondary Damage")
@export var has_secondary_damage: bool
@export var secondary_type: Creature.Type
@export_range(0, 999, 1, "or_greater") var min_secondary_damage: int = 0
@export_range(0, 999, 1, "or_greater") var max_secondary_damage: int = 0


# Public
func get_hit(modifier: int = 0) -> bool:
	return randf() < hit_chance + (float(modifier) / 20)

func get_crit(modifier: int = 0) -> bool:
	return randf() < crit_chance + (float(modifier) / 20)

func get_damage(is_crit: bool, modifier: int = 0) -> int:
	var ret = randi_range(min_damage, max_damage) + modifier
	if is_crit:
		ret *= crit_multiplier
	return ret
	
func get_secondary_damage(is_crit: bool, modifier: int = 0) -> int:
	var ret = randi_range(min_secondary_damage, max_secondary_damage) + modifier
	if is_crit:
		ret *= crit_multiplier
	return ret
