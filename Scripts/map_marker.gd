class_name MapMarker extends Marker

enum Icon{ TREASURE, FIGHT, COMPLETED_FIGHT }

const TEXTURES: Dictionary = {
	Icon.TREASURE: Rect2(0, 16, 16, 16),
	Icon.FIGHT: Rect2(16, 16, 16, 16), 
	Icon.COMPLETED_FIGHT: Rect2(16, 0, 16, 16)
}

@onready var anim = $AnimationPlayer
var state: Icon = Icon.FIGHT

@export var mobs: Array[MobInfo]
@export var boss_mobs: Array[MobInfo]
@export var items: Array[Resource]

# Engine
func _ready() -> void:
	if !has_mobs():
		if has_loot():
			_change_type(Icon.TREASURE)
		else:
			_change_type(Icon.COMPLETED_FIGHT)

func _enter_tree() -> void:
	_ready()


# Public
func has_mobs() -> bool:
	return !mobs.is_empty() or !boss_mobs.is_empty()

func has_loot() -> bool:
	return !items.is_empty()

func fight():
	var temp = self.duplicate()
	_clear_mobs()
	SceneManager.start_fight(temp)

func take(force_loot = false):
	if force_loot or !has_mobs():
		ItemManager.take(items.duplicate())
		_clear_items()
		_ready()


# Private
func _clear_mobs():
	mobs.clear()
	boss_mobs.clear()

func _clear_items():
	items.clear()

func _change_type(new_type: Icon):
	state = new_type
	$Sprite2D.texture.region = TEXTURES[new_type]
