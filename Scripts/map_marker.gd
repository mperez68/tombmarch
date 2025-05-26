class_name MapMarker extends Area2D


var grid_position: Vector2i = Vector2i.ZERO
var grid: TileMapLayer
var conceal_grid: TileMapLayer


# Public
func center():
	position = grid.map_to_local(grid_position) * grid.scale
