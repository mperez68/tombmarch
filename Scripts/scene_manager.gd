extends Node

var fight_info: MapMarker
var dungeon: PackedScene = PackedScene.new()

@onready var delay: Timer = $ChangeDelay

# Public
func start_fight(info: MapMarker):
	fight_info = info.duplicate()
	dungeon.pack(get_tree().current_scene)
	get_tree().call_deferred("change_scene_to_file", "res://PrimaryScenes/fight_room.tscn")
	
func end_fight():
	delay.start()

func _end_fight():
	fight_info = null
	get_tree().call_deferred("change_scene_to_packed", dungeon)
