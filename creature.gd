class_name Creature extends Area2D

enum Type{ SLASHING, PIERCING, BLUDGEONING, BURNING, CHILLING, SHOCKING }
enum Status{ READY, EXPENDED }

signal expend_character

@onready var hl = $Highlight
@onready var hover = $Hover
@onready var anim = $AnimationPlayer
@onready var panel = $CreaturePanel

@export_range(1, 999, 1, "or_greater") var max_hp = 10
@onready var hp = max_hp
@export_range(0, 999, 1, "or_greater") var max_mp = 0
@onready var mp = max_mp
@export var weapon: Weapon
@export var armor: Node
@export var inventory: Array[Node] = []

var status: Status = Status.READY
var is_player: bool = false

# Engine
func _ready() -> void:
	panel.set_bars(self)


# Public
func attack(target: Creature):
	anim.play("attack")
	target._damage(1, 0)
	return				# TODO
	if (weapon.get_hit()):
		var is_crit = weapon.get_crit()
		if (is_crit):
			print("Crit")
		else:
			print("Hit")
		target._damage(weapon.get_damage(is_crit), weapon.damage_type)
		if (weapon.has_secondary_damage):
			target._damage(weapon.get_secondary_damage(is_crit), weapon.damage_type)
	else:
		print("Miss")

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
func _damage(value: int, type: Type):
	anim.play("damage")
	hp -= value
	panel.set_hp(hp)
	if is_dead():
		_die()

func _die():
	panel.visible = false
	anim.play("die")


# Events
func _on_mouse_entered() -> void:
	hover.visible = true

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
	elif anim_name != "idle_expended" and status == Status.EXPENDED:
		anim.play("idle_expended")
