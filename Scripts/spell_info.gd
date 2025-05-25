class_name SpellInfo extends Resource

enum SpellNames{ FIREBLAST, HEAL }

const SPELL_SCENES: Dictionary = {
	SpellNames.FIREBLAST: preload("res://Spells/fireblast.tscn"),
	SpellNames.HEAL: preload("res://Spells/heal.tscn")
}

@export var spell: SpellNames
@export_range(1, 3, 1) var level: int = 1

var ref_pointer: Spell

func display_name() -> String:
	return SpellNames.keys()[spell]

func retrieve() -> Spell:
	if !is_instance_valid(ref_pointer):
		ref_pointer = generate()
	return ref_pointer

func generate() -> Spell:
	var ret = SPELL_SCENES[spell].instantiate()
	ret.level = level
	return ret
