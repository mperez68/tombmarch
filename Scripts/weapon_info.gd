class_name WeaponInfo extends Resource

enum Weapons{ BOW, MACE, STAFF }
enum Enhancements{ NONE, BURNING, BRUTAL }

const BASE_REFERENCES: Dictionary = {
	Weapons.BOW: preload("res://Weapons/bow.tscn"),
	Weapons.MACE: preload("res://Weapons/mace.tscn"),
	Weapons.STAFF: preload("res://Weapons/staff.tscn")
}

@export var weapon_type: Weapons
@export var weapon_name: String
@export_range(0, 3) var level: int
@export var enhancement: Enhancements

func generate() -> Node:
	var ret: Weapon = BASE_REFERENCES[weapon_type].instantiate()
	
	if !weapon_name.is_empty():
		ret.weapon_name = weapon_name
	
	ret.hit_chance += float(level) / 10.0
	ret.min_damage += level
	ret.max_damage += level
	
	match enhancement:
		Enhancements.BURNING:
			ret.has_secondary_damage = true
			ret.secondary_type = Creature.Type.BURNING
			ret.min_secondary_damage = 2
			ret.max_secondary_damage = 3
		Enhancements.BRUTAL:
			ret.crit_chance *= 2
			ret.crit_multiplier += 1
	
	return ret

# Weapon stats: hit_chance, crit_chance, crit_multiplier, damage_type, min_damage, max_damage
#				has_seondary_damage, secondary_type, min_secondary_damage, max_secondary_damage
