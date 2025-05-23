extends Node

signal set_ui(visible: bool)

enum Select{ DISABLED, NO_ACTIVE, ACTIVATED, TARGET }

@onready var sfx = $SfxManager

var actor: Creature
var targets: Array[Creature]
var select_state: Select = Select.DISABLED
var target_limit: int = 0


# Public
func select(target: Creature):
	if target.is_dead():
		return
	match (select_state):
		Select.NO_ACTIVE:
			if target.is_player and target.status == Creature.Status.READY:
				actor = target
				actor.anim.play("selected")
				sfx.play(sfx.Sfx.DOUBLE_CLICK)
				change_state(Select.ACTIVATED, false)
				set_ui.emit(true)
		Select.ACTIVATED:
			if target.is_player and target.status == Creature.Status.READY:
				actor = target
				actor.anim.play("selected")
				sfx.play(sfx.Sfx.DOUBLE_CLICK)
		Select.TARGET:
			if target.is_player:
				change_state(Select.NO_ACTIVE, true)
				select(target)
			_select_targets(target)

func clear():
	for target in targets:
		target.select(false)
	actor = null
	targets.clear()

func change_state(new_state: Select, reset: bool = true, new_limit: int = 0):
	if reset:
		clear()
	target_limit = new_limit
	select_state = new_state
	if new_state == Select.DISABLED:
		set_ui.emit(false)


# Private
func _select_targets(target: Creature):
	if targets.has(target):
		targets.remove_at(targets.find(target))
		target.select(false)
		sfx.play(sfx.Sfx.CLICK)
	elif targets.size() < target_limit and !target.is_player and !target.is_dead():
		targets.push_front(target)
		target.select(true)
		# If limit reached, do action
		if targets.size() == target_limit:
			for t in targets:
				actor.attack(t)	# TODO appropriate chosen action
			var temp = actor
			change_state(Select.NO_ACTIVE)
			set_ui.emit(false)
			temp.expend()
		else:
			sfx.play(sfx.Sfx.CLICK)
