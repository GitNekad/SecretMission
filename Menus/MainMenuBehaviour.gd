extends Node

@export var startButton : Button

func _ready():
	MusicPlayer.playMenuMusic()
	startButton.grab_focus()

func startGame():
	get_tree().change_scene_to_file("res://Menus/SelectPlayers.tscn")
	
func openOptions():
	get_tree().change_scene_to_file("res://Menus/OptionsMenu.tscn")
	
func openHelp():
	get_tree().change_scene_to_file("res://Menus/HelpMenu.tscn")

func quitGame():
	get_tree().quit()

func openBluesky():
	OS.shell_open("https://bsky.app/profile/nekkabi.bsky.social")
