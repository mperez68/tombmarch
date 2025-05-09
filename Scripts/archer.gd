class_name Archer extends PlayerCreature

func _ready() -> void:
	super()
	weapon = ItemManager.all_weapons[ItemManager.Weapons.BOW]
