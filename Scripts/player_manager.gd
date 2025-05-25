extends Node

@export var players: Array[PlayerInfo]

# Engine
func _ready() -> void:
	for player in players:
		if is_instance_valid(player.equipped_weapon):
			ItemManager.take([player.equipped_weapon])
			player.equipped_weapon.item_owner = player
		if is_instance_valid(player.equipped_armor):
			ItemManager.take([player.equipped_armor])
			player.equipped_armor.item_owner = player

# Public
func generate() -> Array[Creature]:
	var ret: Array[Creature] = []
	for player in players:
		ret.push_back(player.generate())
	return ret

func save(party: Array[Creature]):
	for i in party.size():
		players[i].save(party[i])

# TODO save to memory
func save_game_state():
	pass
