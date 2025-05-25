extends Node

var pointer: NodePath
var fight_info: MapMarker
var dungeon: PackedScene = PackedScene.new()
var fight_success: bool = true

@onready var delay: Timer = $ChangeDelay

# Public
func start_fight(info: MapMarker):
	fight_success = true
	pointer = info.get_path()
	fight_info = info.duplicate()
	dungeon.pack(get_tree().current_scene)
	get_tree().call_deferred("change_scene_to_file", "res://PrimaryScenes/fight_room.tscn")
	
func end_fight():
	fight_info = null
	PlayerController.change_state(PlayerController.Select.DISABLED)
	delay.start()

func _end_fight():
	get_tree().call_deferred("change_scene_to_packed", dungeon)
