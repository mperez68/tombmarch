extends Node2D

enum Turn{ NONE, PLAYER, MOBS, BOSS, ENVIRONMENT }

const PLAYER_LINE: Array[Vector2i] = [ Vector2i(9, 6), Vector2i(16, 6) ]
const ENEMY_LINE: Array[Vector2i] = [ Vector2i(10, -2), Vector2i(17, -2) ]
const BOSS_LINE: Array[Vector2i] = [ Vector2i(10, 0), Vector2i(17, 0) ]

@onready var pass_timer: Timer = $TurnPassTimer
@onready var grid: TileMapLayer = $Terrain

var active: Turn = Turn.NONE

var creatures: Dictionary


# Engine
func _ready() -> void:
	# Initialize lists
	for turn in Turn.size():
		creatures[turn] = []
	
	creatures[Turn.PLAYER] = PlayerManager.generate()
	
	# Populate lines
	for mob in SceneManager.fight_info.mobs:
		creatures[Turn.MOBS].push_front(mob.generate())
	for boss in SceneManager.fight_info.boss_mobs:
		creatures[Turn.BOSS].push_front(boss.generate())
	
	# Populate AI Controllers targets
	AiController.players = creatures[Turn.PLAYER]
	
	# Line players
	for i in creatures[Turn.PLAYER].size():
		creatures[Turn.PLAYER][i].expend_character.connect(_check_turn)
		creatures[Turn.PLAYER][i].position = grid.scale * lerp(
			grid.map_to_local(PLAYER_LINE[0]),
			grid.map_to_local(PLAYER_LINE[1]),
			float(i + 0.5) / float(creatures[Turn.PLAYER].size()))
		add_child(creatures[Turn.PLAYER][i])
	
	# Line mobs
	for i in creatures[Turn.MOBS].size():
		creatures[Turn.MOBS][i].expend_character.connect(_check_turn)
		creatures[Turn.MOBS][i].position = grid.scale * lerp(
			grid.map_to_local(ENEMY_LINE[0]),
			grid.map_to_local(ENEMY_LINE[1]),
			float(i + 0.5) / float(creatures[Turn.MOBS].size()))
		add_child(creatures[Turn.MOBS][i])
	
	# Line boss
	for i in creatures[Turn.BOSS].size():
		creatures[Turn.BOSS][i].expend_character.connect(_check_turn)
		creatures[Turn.BOSS][i].position = grid.scale * lerp(
			grid.map_to_local(BOSS_LINE[0]),
			grid.map_to_local(BOSS_LINE[1]),
			float(i + 0.5) / float(creatures[Turn.BOSS].size()))
		add_child(creatures[Turn.BOSS][i])
	
	pass_timer.start()

func _enter_tree() -> void:
	MusicManager.play(MusicManager.Song.FIGHT)

# Public
func pass_turn():
	for creature in creatures[active]:
		if !creature.is_dead():
			creature.reset()
	# Increment to next valid actor
	active = ((active + 1) % Turn.size()) as Turn
	while creatures[active].size() == 0:
		active = ((active + 1) % Turn.size()) as Turn
	
	# Take Turn
	if active == Turn.PLAYER:
		PlayerController.change_state(PlayerController.Select.NO_ACTIVE)
		for creature in creatures[Turn.PLAYER]:
			if !creature.is_dead():
				creature.anim.play("selected")
	else:
		if _has_living(creatures[active]):
			PlayerController.change_state(PlayerController.Select.DISABLED)
			AiController.enqueue(creatures[active])
		else:
			pass_turn()


# Private
func _has_living(list: Array) -> bool:
	for creature in list:
		if !creature.is_dead():
			return true
	return false


# Signal
func _check_turn():
	# Check if fight is over
	if !_has_living(creatures[Turn.PLAYER]) or (!_has_living(creatures[Turn.MOBS]) and !_has_living(creatures[Turn.BOSS])):
		PlayerManager.save(creatures[Turn.PLAYER])
		SceneManager.end_fight()
	
	# Check if turn is over
	for creature in creatures[active]:
		if creature.status == Creature.Status.READY and !creature.is_dead():
			return
	pass_timer.start()
