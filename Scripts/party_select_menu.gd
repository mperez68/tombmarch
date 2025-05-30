extends Control

var temp_player_info: PlayerInfo
var temp_player: PlayerCreature


# Public
func show_start():
	%StartButton.disabled = !is_instance_valid(temp_player_info) or %DisplayNameEdit.text.is_empty()


# Signals
func _on_class_button_pressed(selected: PlayerInfo.PlayerClass) -> void:
	if is_instance_valid(temp_player):
		temp_player.queue_free()
	temp_player_info = PlayerInfo.new()
	temp_player_info.player_class = selected
	temp_player = temp_player_info.generate()
	temp_player.position = %DisplayCreature.position
	%DisplayCreature.add_sibling(temp_player)
	temp_player.panel.visible = false
	show_start()

func _on_display_name_edit_text_changed() -> void:
	show_start()

func _on_start_button_pressed() -> void:
	temp_player_info.display_name = %DisplayNameEdit.text
	temp_player_info.equipped_weapon = WeaponInfo.new()
	temp_player_info.equipped_weapon.weapon_type = WeaponInfo.Weapons.DAGGER
	PlayerManager.set_party([temp_player_info])
	SceneManager.start_dungeon()
