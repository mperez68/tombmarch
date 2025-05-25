extends Node

const MAX_PARTY: int = 3

@export var players: Array[PlayerInfo]

# Engine
func _ready() -> void:
	for player in players:
		player.init()
		player.level_up.connect(_on_level_up)
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

func save(party: Array[Creature], exp_reward: int = 0):
	for i in party.size():
		if exp_reward > 0:
			@warning_ignore("integer_division")
			players[i].gain_experience(exp_reward / party.size())
		players[i].save(party[i])

# TODO save to memory
func save_game_state():
	pass

# Signals
func _on_level_up(player: PlayerInfo):	# TODO
	print(player.display_name, " is now level ", player.experience_level, "!!!")
