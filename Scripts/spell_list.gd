extends ItemList

# Engine
func _ready() -> void:
	PlayerController.change_actor.connect(hide)


# Public
func populate():
	if !is_instance_valid(PlayerController.actor):
		hide()
		return
	size.x = 1
	size.y = 1
	for spell in PlayerController.actor.spells:
		add_item(str(spell.display_name(), " ", spell.level), null, spell.retrieve().mana_cost <= PlayerController.actor.mp)
	if PlayerController.actor.spells.is_empty():
		add_item("NONE", null, false)


# Signals
func _on_item_selected(index: int) -> void:
	var targets = PlayerController.actor.spells[index].retrieve().target_limit
	PlayerController.change_state(PlayerController.Select.TARGET, false, targets)
	PlayerController.spell = PlayerController.actor.spells[index].retrieve()
	hide()	# TODO feedback for selected spell
