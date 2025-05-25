extends Control

@onready var player_list: ItemList = %PlayerList

@onready var title: Label = %MemberTitle

@onready var level_text: Label = %CurrentLevel
@onready var exp_text: Label = %CurrentEXP
@onready var max_exp_text: Label =  %MaxEXP
@onready var hp_text: Label = %CurrentHP
@onready var max_hp_text: Label = %MaxHP
@onready var mp_text: Label = %CurrentMP
@onready var max_mp_text: Label = %MaxMP

@onready var stre: Label = %StrVal
@onready var agi: Label = %AgiVal
@onready var intel: Label = %IntVal
@onready var str_button: Button = %StrInc
@onready var agi_button: Button = %AgiInc
@onready var int_button: Button = %IntInc

@onready var weapon_text: Label = %WeapVal
@onready var armor_text: Label = %ArmorVal
@onready var desc: Label = %MemberDescription

@onready var unequip_weapon_button: Button = %UnequipWeaponButton
@onready var unequip_armor_button: Button = %UnequipArmorButton

var selected_player: PlayerInfo

# Engine
func _ready() -> void:
	populate()


# Public
func populate() -> void:
	player_list.clear()
	clear()
	for player in PlayerManager.players:
		player_list.add_item(player.display_name)
	player_list.select(0)
	_on_player_list_item_selected(0)

func clear() -> void:
	level_text.text = "-"
	exp_text.text = "      -      "
	max_exp_text.text = "      -      "
	hp_text.text = "-"
	max_hp_text.text = "-"
	mp_text.text = "-"
	max_mp_text.text = "-"
	title.text = " "
	stre.text = "--"
	agi.text = "--"
	intel.text = "--"
	str_button.disabled = true
	agi_button.disabled = true
	int_button.disabled = true
	weapon_text.text = "   -   "
	armor_text.text = "   -   "
	desc.text = "..."
	unequip_weapon_button.disabled = true
	unequip_armor_button.disabled = true

# Private
func _update_stat_buttons():
	if selected_player.available_stat_points > 0:
		str_button.disabled = false
		agi_button.disabled = false
		int_button.disabled = false
	else:
		str_button.disabled = true
		agi_button.disabled = true
		int_button.disabled = true

# Signals
func _on_player_list_item_selected(index: int) -> void:
	clear()
	selected_player = PlayerManager.players[index]
	level_text.text = str(selected_player.experience_level)
	exp_text.text = str(selected_player.experience)
	max_exp_text.text = str(selected_player.experience_level * 1000)
	hp_text.text = str(selected_player.hp)
	max_hp_text.text = str(selected_player.max_hp)
	mp_text.text = str(selected_player.mp)
	max_mp_text.text = str(selected_player.max_mp)
	title.text =  selected_player.display_name
	stre.text = str(selected_player.strength + 10)
	agi.text = str(selected_player.agility + 10)
	intel.text = str(selected_player.intelligence + 10)
	if is_instance_valid(selected_player.equipped_weapon):
		weapon_text.text = selected_player.equipped_weapon.display_name()
		unequip_weapon_button.disabled = false
	if is_instance_valid(selected_player.equipped_armor):
		armor_text.text = selected_player.equipped_armor.display_name()
		unequip_armor_button.disabled = false
	#desc.text = selected_player.description
	_update_stat_buttons()
	

func _on_unequip_weapon_button_pressed() -> void:
	selected_player.equipped_weapon.unequip()
	weapon_text.text = "-"
	unequip_weapon_button.disabled = true

func _on_unequip_armor_button_pressed() -> void:
	selected_player.equipped_armor.unequip()
	armor_text.text = "-"
	unequip_armor_button.disabled = true

func _on_stat_inc_pressed(stat: Creature.Stats) -> void:
	if selected_player.available_stat_points <= 0:
		_update_stat_buttons()
		return
	selected_player.available_stat_points -= 1
	match (stat):
		Creature.Stats.STRENGTH:
			selected_player.strength += 1
			selected_player.hp += 1
			selected_player.max_hp += 1
			stre.text = str(selected_player.strength + 10)
			hp_text.text = str(selected_player.hp)
			max_hp_text.text = str(selected_player.max_hp)
		Creature.Stats.AGILITY:
			selected_player.agility += 1
			agi.text = str(selected_player.agility + 10)
		Creature.Stats.INTELLIGENCE:
			selected_player.mp += 1
			selected_player.max_mp += 1
			selected_player.intelligence += 1
			intel.text = str(selected_player.intelligence + 10)
			mp_text.text = str(selected_player.mp)
			max_mp_text.text = str(selected_player.max_mp)
	_update_stat_buttons()
	
