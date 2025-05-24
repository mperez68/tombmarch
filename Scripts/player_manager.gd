extends Node

@export var players: Array[PlayerInfo]


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
