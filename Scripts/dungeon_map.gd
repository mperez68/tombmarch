extends Node2D

@onready var grid = $Map
@onready var conceal_grid = $Concealment
@onready var player: PlayerMarker = $PlayerMarker

var menu_open: bool = false

# Engine
func _ready() -> void:
	conceal_grid.visible = true
	
	# Center markers
	for child in get_children():
		if child is Marker:
			child.grid = grid
			child.conceal_grid = conceal_grid
			child.grid_position = grid.local_to_map(child.position / grid.scale)
			child.center()
	# connect reveal, do initial reveal
	if !player.position_updated.is_connected(_reveal):
		player.position_updated.connect(_reveal)
	_reveal(player.grid_position)

func _input(event: InputEvent) -> void:
	if menu_open:
		return
	
	var direction = Vector2i.ZERO
	if event.is_action_pressed("ui_up"):
		direction = Vector2i.UP
	elif event.is_action_pressed("ui_down"):
		direction = Vector2i.DOWN
	elif event.is_action_pressed("ui_left"):
		direction = Vector2i.LEFT
	elif event.is_action_pressed("ui_right"):
		direction = Vector2i.RIGHT
	
	if direction != Vector2i.ZERO:
		player.move_to_position(direction)

func _enter_tree() -> void:
	MusicManager.play(MusicManager.Song.DUNGEON)


# Private
func _reveal(grid_position: Vector2i):
	conceal_grid.set_cell(grid_position, -1)
	var neightbor_grid_positions: Array[Vector2i] = grid.get_surrounding_cells(grid_position)
	for pos in neightbor_grid_positions:
		if grid.get_cell_tile_data(pos) != null and conceal_grid.get_cell_tile_data(pos) != null:
			conceal_grid.set_cell(pos, 0, Vector2i(0, 4))


# Signals
func _on_ui_menu_change(open: bool) -> void:
	menu_open = open
