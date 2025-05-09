class_name Wizard extends PlayerCreature

func _ready() -> void:
	super()
	weapon = ItemManager.all_weapons[ItemManager.Weapons.STAFF]
