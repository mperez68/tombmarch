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
	AiController.players = creatures[Turn.PLAYER]
	pass_turn()


# Public
func pass_turn():
	for creature in creatures[active]:
		creature.reset()
	# Increment to next valid actor
	active = ((active + 1) % Turn.size()) as Turn
	while creatures[active].size() == 0:
		active = ((active + 1) % Turn.size()) as Turn
	# Take Turn
	if active == Turn.PLAYER:
		PlayerController.change_state(PlayerController.Select.NO_ACTIVE)
		for creature in creatures[Turn.PLAYER]:
			creature.anim.play("selected")
	else:
		PlayerController.change_state(PlayerController.Select.DISABLED)
		AiController.enqueue(creatures[active])

# Signal
func _check_turn():
	for creature in creatures[active]:
		if creature.status == Creature.Status.READY and !creature.is_dead():
			return
	pass_timer.start()
