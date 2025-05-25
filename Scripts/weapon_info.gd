class_name WeaponInfo extends Resource

enum Weapons{ BOW, MACE, STAFF }
enum Enhancements{ NONE, BURNING, BRUTAL }

const BASE_REFERENCES: Dictionary = {
	Weapons.BOW: preload("res://Weapons/bow.tscn"),
	Weapons.MACE: preload("res://Weapons/mace.tscn"),
	Weapons.STAFF: preload("res://Weapons/staff.tscn")
}

const WEAP_DESC: Dictionary = {
	Weapons.BOW: "It goes twang!",
	Weapons.MACE: "It goes bonk!",
	Weapons.STAFF: "It goes whoosh!"
}

@export var weapon_type: Weapons
@export var weapon_name: String
@export_range(0, 3) var level: int
@export var enhancement: Enhancements

var item_owner: PlayerInfo
var ref_pointer: Weapon

# Public
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

func retrieve() -> Weapon:
	if !is_instance_valid(ref_pointer):
		var ref = generate()
		ItemManager.add_child(ref)
		ref_pointer = ref

	return ref_pointer

func display_name() -> String:
	if !weapon_name.is_empty():
		return weapon_name
	var prefix: String = ""
	if enhancement != Enhancements.NONE:
		prefix = Enhancements.keys()[enhancement] + " "
	return prefix + Weapons.keys()[weapon_type]

func description() -> String:
	var ret: String = WEAP_DESC[weapon_type]
	ret += "\n\n"
	ret += str("STAT: ", (Creature.Stats.keys()[retrieve().primary_stat]))
	if retrieve().has_secondary_damage:
		ret += str(" + ", (Creature.Stats.keys()[retrieve().secondary_stat]))
	ret += str("\n", "HIT: ", int(retrieve().hit_chance * 100), "\n")
	ret += str("CRIT: ", int(retrieve().crit_chance * 100), ", MULT: ", int(retrieve().crit_multiplier), "\n")
	ret += str(retrieve().min_damage, " - ", retrieve().max_damage, " ", Creature.Type.keys()[retrieve().damage_type])
	if retrieve().has_secondary_damage:
		ret += str(", ", retrieve().min_secondary_damage, " - ", retrieve().max_secondary_damage, " ", Creature.Type.keys()[retrieve().secondary_type])
	return ret

func equip(player: PlayerInfo):
	if is_instance_valid(item_owner):
		item_owner.equipped_weapon.unequip()
	item_owner = player
	
	if is_instance_valid(player.equipped_weapon):
		player.equipped_weapon.unequip()
	player.equipped_weapon = self

func unequip():
	if item_owner == null:
		return
	item_owner.equipped_weapon = null
	item_owner = null
