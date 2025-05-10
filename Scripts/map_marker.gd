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

# Engine
func _ready() -> void:
	$Sprite2D.texture.region = TEXTURES[icon]


# Signals
func _on_mouse_entered() -> void:
	anim.play("hover")

func _on_mouse_exited() -> void:
	anim.play("return")
