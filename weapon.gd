class_name Weapon extends Node

@export var weapon_name: String
@export_range(0,1) var hit_chance: float = 0.5
@export_range(0,1) var crit_chance: float = 0.2
@export_group("Primary Damage")
@export var damage_type: Creature.Type
@export var min_damage: int = 1
@export var max_damage: int = 2
@export_group("Secondary Damage")
@export var has_secondary_damage: bool
@export var secondary_type: Creature.Type
@export var min_secondary_damage: int = 0
@export var max_secondary_damage: int = 0


# Public
func get_hit(modifier: float = 0) -> bool:
	return randf() < hit_chance + modifier

func get_crit(modifier: float = 0) -> bool:
	return randf() < crit_chance + modifier

func get_damage(is_crit: bool) -> int:
	return randi_range(min_damage, max_damage)
	
func get_secondary_damage(is_crit: bool) -> int:
	return randi_range(min_secondary_damage, max_secondary_damage)
