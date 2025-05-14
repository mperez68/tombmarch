class_name SpellInfo extends Resource

enum SpellNames{ FIREBALL, HEAL, ENCHANT_WEAPON, CURSE }

@export var spell: SpellNames
@export_range(0, 5, 1) var charges: int
@export_range(1, 3, 1) var level: int
