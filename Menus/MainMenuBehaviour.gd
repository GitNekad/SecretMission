extends Node

@export var startButton : Button

func _ready():
	startButton.grab_focus()

func startGame():
	get_tree().change_scene_to_file("res://Menus/SelectPlayers.tscn")

func quitGame():
	get_tree().quit()
