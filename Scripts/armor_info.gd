class_name ArmorInfo extends Resource

enum Armors{ SHIELD }
enum Enhancements{ NONE, SPIKED }

const BASE_REFERENCES: Dictionary = {
	Armors.SHIELD: preload("res://Armor/shield.tscn")
}

const ARMOR_DESC: Dictionary = {
	Armors.SHIELD: "A metal dinner plate."
}

@export var armor_type: Armors
@export var armor_name: String
@export_range(0, 3) var level: int
@export var enhancement: Enhancements

var item_owner: PlayerInfo
var reference: Armor

func generate() -> Node:
	var ret: Armor = BASE_REFERENCES[armor_type].instantiate()
	
	if !armor_name.is_empty():
		ret.armor_name = armor_name
	
	ret.block_chance += 0.1 * level
	
	match enhancement:
		Enhancements.SPIKED:
			pass	# TODO
	
	return ret

func retrieve() -> Armor:
	if !is_instance_valid(reference):
		var ref = generate()
		ItemManager.add_child(ref)
		reference = ref

	return reference

func display_name() -> String:
	if !armor_name.is_empty():
		return armor_name
	var prefix: String
	if enhancement != Enhancements.NONE:
		prefix = Enhancements.keys()[enhancement] + " "
	return prefix + Armors.keys()[armor_type]

func description() -> String:
	var ret: String = ARMOR_DESC[armor_type]
	ret += "\n\n"
	ret += str("BLOCK: ", int(retrieve().block_chance * 100), "\n")
	return ret
