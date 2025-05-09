extends Node

enum State{ IDLE, RUNNING, PAUSED }

@onready var timer: Timer = $PauseTimer

var state = State.IDLE
var queue: Array[Creature]
var players: Array

func enqueue(creatures: Array):
	queue.append_array(creatures)
	if state == State.IDLE:
		start()

func start():
	# End engine if queue is empty
	if queue.is_empty():
		state = State.IDLE
		return
	
	# Do turn
	state = State.RUNNING
	var temp: Creature = queue.pop_front()
	while temp.is_dead():
		if queue.is_empty():
			state = State.IDLE
			return
		temp = queue.pop_front()
	
	temp.attack(players.pick_random())
	temp.expend()
	
	# Pause for player reading
	state = State.PAUSED
	timer.start()
