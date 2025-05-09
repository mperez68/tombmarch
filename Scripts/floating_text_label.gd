extends RichTextLabel

const SPEED = 32
const PREFIX = "[font_size=32]"
const POSTFIX = "[/font_size]"

# Engine
func _ready() -> void:
	text = PREFIX + text + POSTFIX

func _process(delta: float) -> void:
	position += Vector2(0, -SPEED) * delta


# Signals
func _on_lifetime_timeout() -> void:
	queue_free()
