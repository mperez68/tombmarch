extends Node

var pointer: NodePath
var fight_info: MapMarker
var dungeon: PackedScene = PackedScene.new()
var fight_success: bool = true
var can_leave: bool = false

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

func start_dungeon():
	get_tree().call_deferred("change_scene_to_file", "res://PrimaryScenes/dungeon_map.tscn")	# TODO previous party select screen

func end_dungeon():
	get_tree().call_deferred("change_scene_to_file", "res://PrimaryScene/party_select_menu.tscn")


# Private
func _end_fight():
	get_tree().call_deferred("change_scene_to_packed", dungeon)
