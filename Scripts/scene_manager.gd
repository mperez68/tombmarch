extends Node

var fight_info: MapMarker


# Public
func start_fight(info: MapMarker):
	fight_info = info.duplicate()
	var room: PackedScene = load("res://PrimaryScenes/fight_room.tscn")
	get_tree().change_scene_to_packed(room)

func end_fight():
	fight_info = null
	var dungeon: PackedScene = load("res://PrimaryScenes/dungeon_map.tscn")
	get_tree().change_scene_to_packed(dungeon)
