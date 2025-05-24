extends Node

enum Song {NONE, DUNGEON, FIGHT}

@onready var songs: Dictionary = {
	Song.DUNGEON: $Dungeon,
	Song.FIGHT: $Fight
}

var current_song: Song

func play(song: Song, force_start: bool = false):
	if !is_node_ready():
		await ready
	if song == Song.NONE:
		stop()
		return
	if song == current_song and !force_start:
		return
	current_song = song
	stop()
	songs[song].play()

func stop():
	for player in get_children():
		player.stop()
