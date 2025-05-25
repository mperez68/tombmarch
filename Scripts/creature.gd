class_name Creature extends Area2D

const MAX_STAT: int = 10
const floating_label = preload("res://UI/floating_text_label.tscn")

enum Stats{ STRENGTH, AGILITY, INTELLIGENCE }
enum Type{ SLASHING, PIERCING, BLUDGEONING, BURNING, CHILLING, SHOCKING }
enum Status{ READY, EXPENDED }

signal expend_character

@onready var hl = $Highlight
@onready var hover = $Hover
@onready var anim = $AnimationPlayer
@onready var panel = $CreaturePanel
@onready var sfx = $SfxManager
@onready var fists = $Fists

@export var display_name: String = "CREATURE"
@export var is_player: bool = false
@export_group("Stats")
@export_range(1, 1, 1, "or_greater") var max_hp = 10
var hp: int
@export_range(0, 1, 1, "or_greater") var max_mp = 0
var mp: int
@export_range(0, MAX_STAT, 1, "hide_slider") var strength: int
@export_range(0, MAX_STAT, 1, "hide_slider") var agility: int
@export_range(0, MAX_STAT, 1, "hide_slider") var intelligence: int
@export_group("Equipment")
@export var weapon: Weapon
@export var armor: Armor

var status: Status = Status.READY


# Engine
func _ready() -> void:
	anim.seek(randf_range(0,4))
	panel.set_bars(self)


# Public
func attack(target: Creature):
	if !is_instance_valid(weapon):
		weapon = fists
	var temp = floating_label.instantiate()
	temp.position = target.position - (temp.size / 2)
	anim.play("attack")
	if (weapon.get_hit(_get_modifier())):
		var is_crit = weapon.get_crit(agility)
		if (is_crit):
			temp.self_modulate = Color.RED
		var dmg = weapon.get_damage(is_crit, _get_modifier())
		target._damage(dmg, weapon.damage_type)
		temp.text = str(dmg)
		if (weapon.has_secondary_damage):
			var secondary_dmg = weapon.get_secondary_damage(is_crit, _get_modifier(false))
			target._damage(secondary_dmg, weapon.damage_type)
			temp.text += str(" + ", secondary_dmg)
		sfx.play(sfx.Sfx.HIT)
	else:
		temp.text = "Miss"
		sfx.play(sfx.Sfx.MISS)
	add_sibling(temp)
	if weapon == fists:
		weapon = null

func cast(target: Creature):
	pass

func heal(target: Creature):
	pass

func use(target: Creature, item: String):
	pass

func run() -> bool:
	return true

func is_dead() -> bool:
	return hp <= 0

func select(new_state: bool = !hl.visible):
	hl.visible = new_state

func expend():
	status = Status.EXPENDED
	expend_character.emit()
	if anim.current_animation == "idle":
		anim.play("idle_expended")

func reset():
	if !is_dead():
		status = Status.READY
		anim.play("idle")


# Private
func _damage(value: int, type: Type, mortal: bool = false):
	if !mortal and armor != null and armor.block():
		var temp = floating_label.instantiate()
		temp.position = position - (temp.size / 2)
		temp.text = "Block"
		add_sibling(temp)
		return
	anim.play("damage")
	sfx.play(sfx.Sfx.DAMAGE)
	hp -= value
	panel.set_hp(hp)
	if is_dead():
		_die()

func _get_modifier(is_primary = true) -> int:
	var check = weapon.primary_stat
	if !is_primary:
		check = weapon.secondary_stat
	match check:
		Stats.STRENGTH:
			return strength
		Stats.AGILITY:
			return agility
		Stats.INTELLIGENCE:
			return intelligence
	return 0

func _die():
	hover.visible = false
	panel.visible = false
	anim.play("die")
	sfx.play(sfx.Sfx.DEATH)


# Events
func _on_mouse_entered() -> void:
	hover.visible = !is_dead()

func _on_mouse_exited() -> void:
	hover.visible = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		PlayerController.select(self)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		return
	if anim_name != "idle" and status == Status.READY:
		anim.play("idle")
	elif anim_name != "idle_expended" and status == Status.EXPENDED and is_player:
		anim.play("idle_expended")
