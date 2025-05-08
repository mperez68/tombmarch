class_name PlayerCreature extends Creature

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		hl.visible = false
		anim.play("selected")
