class_name Wizard extends PlayerCreature

func _ready() -> void:
	super()
	weapon = ItemManager.base_weapons[ItemManager.Weapons.STAFF]
