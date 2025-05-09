extends Node

var fight_info: MapMarker
var dungeon: PackedScene = PackedScene.new()


# Public
func start_fight(info: MapMarker):
	fight_info = info.duplicate()
	dungeon.pack(get_tree().current_scene)
	get_tree().change_scene_to_file("res://PrimaryScenes/fight_room.tscn")

func end_fight():
	fight_info = null
	get_tree().change_scene_to_packed(dungeon)
