class_name RoomMarker extends MapMarker

enum Icon{ NONE, TREASURE, COMPLETED_TREASURE, FIGHT, COMPLETED_FIGHT, BOSS_FIGHT, COMPLETED_BOSS_FIGHT }

const TEXTURES: Dictionary = {
	Icon.TREASURE: Rect2(0, 16, 16, 16),
	Icon.COMPLETED_TREASURE: Rect2(0, 32, 16, 16),
	Icon.FIGHT: Rect2(16, 16, 16, 16), 
	Icon.COMPLETED_FIGHT: Rect2(16, 32, 16, 16),
	Icon.BOSS_FIGHT: Rect2(32, 16, 16, 16),
	Icon.COMPLETED_BOSS_FIGHT: Rect2(32, 32, 16, 16)
}

@onready var anim = $AnimationPlayer
var state: Icon = Icon.NONE

@export var mobs: Array[MobInfo]
@export var boss_mobs: Array[MobInfo]
@export var items: Array[InventoryInfo]
@export var final_fight: bool = false

# Engine
func _ready() -> void:
	if state != Icon.NONE:
		return
	if has_mobs():
		if has_boss():
			_change_type(Icon.BOSS_FIGHT)
		else:
			_change_type(Icon.FIGHT)
	else:
		if has_loot():
			_change_type(Icon.TREASURE)
		else:
			queue_free()


# Public
func has_mobs() -> bool:
	return !mobs.is_empty() or !boss_mobs.is_empty()

func has_boss() -> bool:
	return !boss_mobs.is_empty()

func has_loot() -> bool:
	return !items.is_empty()

func fight():
	SceneManager.start_fight(self)

func take(force_loot = false):
	if force_loot or !has_mobs():
		ItemManager.take(items.duplicate())
		_clear_items()


# Private
func _clear_mobs():
	if has_loot():
		_change_type(Icon.TREASURE)
	elif has_boss():
		_change_type(Icon.COMPLETED_BOSS_FIGHT)
	else:
		_change_type(Icon.COMPLETED_FIGHT)
	mobs.clear()
	boss_mobs.clear()
	if final_fight:
		SceneManager.can_leave = true

func _clear_items():
	items.clear()
	if !has_mobs():
		_change_type(Icon.COMPLETED_TREASURE)

func _change_type(new_type: Icon):
	state = new_type
	$Sprite2D.texture.region = TEXTURES[new_type]
