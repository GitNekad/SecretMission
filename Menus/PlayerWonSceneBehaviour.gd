extends Node

@export var xWon : Label

func _ready():
	MusicPlayer.playVictoryMusic()
	if GameManager.players.size() == 0:
		var pointer = GameManager.pointerPack.instantiate()
		self.add_child(pointer)
		pointer.init(0)
		return
	var color = GameManager.playerColors[GameManager.winner]
	xWon.modulate = GameManager.colors[color]
	xWon.text = GameManager.colorsName[color] + " won the game"
	for playerIndex in GameManager.players:
		var pointer = GameManager.pointerPack.instantiate()
		self.add_child(pointer)
		pointer.init(playerIndex)

func playAgain():
	GameManager.asignNpcsToPlayers()
	get_tree().change_scene_to_file("res://Menus/ShowObjective.tscn")

func mainMenu():
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
