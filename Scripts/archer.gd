class_name Archer extends PlayerCreature

func _ready() -> void:
	super()
	weapon = ItemManager.base_weapons[ItemManager.Weapons.BOW]
