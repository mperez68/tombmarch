extends Node2D

enum Turn{ NONE, PLAYER, MOBS, BOSS, ENVIRONMENT }

@onready var pass_timer = $TurnPassTimer

var active: Turn = Turn.NONE

var creatures: Dictionary


# Engine
func _ready() -> void:
	for t in Turn.size():
		creatures[t] = []
	for child in get_children():
		if child is Creature:
			child.expend_character.connect(_check_turn)
			if child is PlayerCreature:
				creatures[Turn.PLAYER].push_back(child)
			if child is EnemyCreature:
				creatures[Turn.MOBS].push_back(child)
	pass_turn()


# Public
func pass_turn():
	for creature in creatures[active]:
		creature.reset()
	active = (active + 1) % Turn.size()
	while creatures[active].size() == 0:
		active = (active + 1) % Turn.size()
	print(creatures[active])

# Signal
func _check_turn():
	for creature in creatures[active]:
		if creature.status == Creature.Status.READY and !creature.is_dead():
			return
	pass_timer.start()
	
