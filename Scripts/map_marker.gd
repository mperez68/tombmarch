class_name MapMarker extends Marker

enum Icon{ TREASURE, FIGHT, COMPLETED_FIGHT }

const TEXTURES: Dictionary = {
	Icon.TREASURE: Rect2(0, 16, 16, 16),
	Icon.FIGHT: Rect2(16, 16, 16, 16), 
	Icon.COMPLETED_FIGHT: Rect2(16, 0, 16, 16)
}

@onready var anim = $AnimationPlayer
@export var icon: Icon = Icon.FIGHT

@export var mobs: Array[MobInfo]
@export var boss_mobs: Array[MobInfo]
@export var items: Array[ItemInfo]

# Engine
func _ready() -> void:
	change_type(icon)


# Public
func clear():
	mobs.clear()
	boss_mobs.clear()
	items.clear()
	change_type(Icon.COMPLETED_FIGHT)


# Private
func change_type(new_type: Icon):
	icon = new_type
	$Sprite2D.texture.region = TEXTURES[new_type]


# Signals
#func _on_mouse_entered() -> void:
	#anim.play("hover")
#
#func _on_mouse_exited() -> void:
	#anim.play("return")


# Engine
#func _exit_tree():
	#if mouse_entered.is_connected(_on_mouse_entered):
		#mouse_entered.disconnect(_on_mouse_entered)
