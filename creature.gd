class_name Creature extends Area2D

enum Type{ SLASHING, PIERCING, BLUDGEONING, BURNING, CHILLING, SHOCKING }

@onready var hl = $Highlight
@onready var hover = $Hover
@onready var anim = $AnimationPlayer
@onready var panel = $CreaturePanel

@export_range(1, 999, 1, "or_greater") var max_hp = 10
@onready var hp = max_hp
@export var max_mp = 0
@onready var mp = max_mp
@export var weapon: Weapon
@export var armor: Node
@export var inventory: Array[Node] = []

# Engine
func _ready() -> void:
	panel.set_bars(self)


# Public
func attack(target: Creature):
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
	return false


# Private
func _damage(value: int, type: Type):
	hp -= value
	panel.set_hp(hp)

func _die():
	panel.visible = false


# Events
func _on_mouse_entered() -> void:
	hover.visible = true

func _on_mouse_exited() -> void:
	hover.visible = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		hl.visible = !hl.visible
