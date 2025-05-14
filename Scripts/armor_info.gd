class_name ArmorInfo extends Resource

enum Armors{ SHIELD }
enum Enhancements{ NONE, SPIKED }

const BASE_REFERENCES: Dictionary = {
	Armors.SHIELD: preload("res://Armor/shield.tscn")
}

@export var armor_type: Armors
@export var armor_name: String
@export_range(0, 3) var level: int
@export var enhancement: Enhancements


func generate() -> Node:
	var ret: Armor = BASE_REFERENCES[armor_type].instantiate()
	
	if !armor_name.is_empty():
		ret.armor_name = armor_name
	
	ret.block_chance += float(level) / 20.0
	
	match enhancement:
		Enhancements.SPIKED:
			pass
	
	return ret
