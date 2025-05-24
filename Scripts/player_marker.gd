class_name PlayerMarker extends Marker

signal position_updated(new_grid_position: Vector2i)

enum State{ DISABLED, READY, MOVING }

var state = State.READY

@onready var pause: Timer = $PauseTimer
@onready var timer: Timer = $MoveTimer


# Public
func move_to_position(direction: Vector2i):
	if grid.get_cell_tile_data(grid_position + direction) == null:
		return
	
	if state == State.READY:
		state = State.MOVING
		grid_position += direction
		if conceal_grid.get_cell_tile_data(grid_position) != null:
			pause.start()
		else:
			_on_pause_timer_timeout()
		position_updated.emit(grid_position)


# Engine
func _on_pause_timer_timeout() -> void:
	timer.start()
	var tween = create_tween()
	tween.tween_property(self, "position", grid.map_to_local(grid_position) * grid.scale, timer.wait_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_move_timer_timeout() -> void:
	state = State.READY
	center()


# Signals
func _on_area_entered(area: Area2D) -> void:
	if area is MapMarker:
		if area.has_mobs():
			area.fight()
		elif area.has_loot():
			area.take()
