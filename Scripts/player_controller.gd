extends Node

signal set_ui(visible: bool)
signal change_actor

enum Select{ DISABLED, NO_ACTIVE, ACTIVATED, TARGET }

@onready var sfx = $SfxManager

var actor: Creature
var targets: Array[Creature]
var select_state: Select = Select.DISABLED
var target_limit: int = 0
var spell: Spell


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
				change_actor.emit()
				spell = null
		Select.ACTIVATED:
			if target.is_player and target.status == Creature.Status.READY:
				actor = target
				actor.anim.play("selected")
				sfx.play(sfx.Sfx.DOUBLE_CLICK)
				change_actor.emit()
				spell = null
		Select.TARGET:
			if target.is_player:
				if !is_instance_valid(spell) or (is_instance_valid(spell) and !spell.target_allies):
					change_state(Select.NO_ACTIVE, true)
					select(target)
			_select_targets(target)

func clear():
	for target in targets:
		target.select(false)
	actor = null
	targets.clear()

## new_state, reset, new_limit
func change_state(new_state: Select, reset: bool = true, new_limit: int = 0):
	if reset:
		clear()
	target_limit = new_limit
	select_state = new_state
	if new_state == Select.DISABLED:
		set_ui.emit(false)

func run(force_pass: bool = false) -> bool:
	actor.expend()
	var ret: bool = (float(actor.agility) / 10) + randf() < 0.5 or force_pass
	if ret:
		actor.anim.play("attack")
		change_state(PlayerController.Select.DISABLED)
	else:
		actor.anim.play("damage")
		change_state(PlayerController.Select.NO_ACTIVE, true)
	return ret


# Private
func _select_targets(target: Creature):
	if targets.has(target):
		targets.remove_at(targets.find(target))
		target.select(false)
		sfx.play(sfx.Sfx.CLICK)
	elif targets.size() < target_limit and _is_valid_target(target):
		targets.push_front(target)
		target.select(true)
		# If limit reached, do action
		if targets.size() == target_limit:
			if is_instance_valid(spell):
				actor.cast(spell, targets)
			else:
				for t in targets:
					actor.attack(t)
			var temp = actor
			change_state(Select.NO_ACTIVE)
			set_ui.emit(false)
			temp.expend()
		else:
			sfx.play(sfx.Sfx.CLICK)

func _is_valid_target(target: Creature) -> bool:
	if target.is_dead():
		return false
	# Spell
	if is_instance_valid(spell):
		if spell.target_enemies and !target.is_player:
			return true
		elif spell.target_allies and target.is_player:
			return true
		elif spell.target_self and target == actor:
			return true
		return false
	# Attack
	return !target.is_player
