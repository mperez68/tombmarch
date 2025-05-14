class_name Creature extends Area2D

const floating_label = preload("res://UI/floating_text_label.tscn")

enum Type{ SLASHING, PIERCING, BLUDGEONING, BURNING, CHILLING, SHOCKING }
enum Status{ READY, EXPENDED }

signal expend_character

@onready var hl = $Highlight
@onready var hover = $Hover
@onready var anim = $AnimationPlayer
@onready var panel = $CreaturePanel

@export_range(1, 1, 1, "or_greater") var max_hp = 10
var hp: int
@export_range(0, 1, 1, "or_greater") var max_mp = 0
var mp: int
@export var weapon: Weapon
@export var armor: Node
@export var inventory: Array[Node] = []
@export var is_player: bool = false

var status: Status = Status.READY


# Engine
func _ready() -> void:
	anim.seek(randf_range(0,4))
	panel.set_bars(self)


# Public
func attack(target: Creature):
	var temp = floating_label.instantiate()
	temp.position = target.position - (temp.size / 2)
	anim.play("attack")
	if (weapon.get_hit()):
		var is_crit = weapon.get_crit()
		if (is_crit):
			temp.self_modulate = Color.RED
		var dmg = weapon.get_damage(is_crit)
		target._damage(dmg, weapon.damage_type)
		temp.text = str(dmg)
		if (weapon.has_secondary_damage):
			var secondary_dmg = weapon.get_secondary_damage(is_crit)
			target._damage(secondary_dmg, weapon.damage_type)
			temp.text += str(" + ", secondary_dmg)
	else:
		temp.text = "Miss"
	add_sibling(temp)

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
	hp -= value
	panel.set_hp(hp)
	if is_dead():
		_die()

func _die():
	hover.visible = false
	panel.visible = false
	anim.play("die")


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
	elif anim_name != "idle_expended" and status == Status.EXPENDED:
		anim.play("idle_expended")
