class_name Fighter extends PlayerCreature

func _ready() -> void:
	super()
	weapon = ItemManager.all_weapons[ItemManager.Weapons.MACE]
