extends Control

@onready var player_list: ItemList = %PlayerList

@onready var title: Label = %MemberTitle

@onready var str: Label = %StrVal
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

func clear() -> void:
	title.text = " "
	str.text = "--"
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


# Signals
func _on_player_list_item_selected(index: int) -> void:
	clear()
	selected_player = PlayerManager.players[index]
	title.text =  selected_player.display_name
	str.text = str(selected_player.strength + 10)
	agi.text = str(selected_player.agility + 10)
	intel.text = str(selected_player.intelligence + 10)
	if is_instance_valid(selected_player.equipped_weapon):
		weapon_text.text = selected_player.equipped_weapon.display_name()
		unequip_weapon_button.disabled = false
	if is_instance_valid(selected_player.equipped_armor):
		armor_text.text = selected_player.equipped_armor.display_name()
		unequip_armor_button.disabled = false
	#desc.text = selected_player.description

func _on_unequip_weapon_button_pressed() -> void:
	selected_player.equipped_weapon.unequip()
	weapon_text.text = "-"
	unequip_weapon_button.disabled = true

func _on_unequip_armor_button_pressed() -> void:
	selected_player.equipped_armor.unequip()
	armor_text.text = "-"
	unequip_armor_button.disabled = true

func _on_stat_inc_pressed(stat: Creature.Stats) -> void:
	match (stat):
		Creature.Stats.STRENGTH:
			selected_player.strength += 1
		Creature.Stats.AGILITY:
			selected_player.agility += 1
		Creature.Stats.INTELLIGENCE:
			selected_player.intelligence += 1
