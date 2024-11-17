extends Node

@export var waitingForPlayersVisuals : Array[Control]

var waitingForPlayers = []
var _readyToReadInputs = false

func _ready():
	MusicPlayer.playMenuMusic()
	GameManager.npcDamageMultiplier = [1,1,1,1,1,1,1,1]
	var unusedColors = [0,1,2,3,4,5,6,7]
	for key in GameManager.playerColors:
		unusedColors.erase(GameManager.playerColors[key])
		waitingForPlayers.append(key)
	for color in unusedColors:
		waitingForPlayersVisuals[color].visible = false
	await get_tree().create_timer(2).timeout
	_readyToReadInputs = true

func _input(event):
	if !_readyToReadInputs:
		return
	for player in waitingForPlayers:
		var affix = GameManager.players[player]
		if event.is_action_pressed("walk_down_"+affix):
			pressedOnCharacter(player, 3)
		elif event.is_action_pressed("walk_up_"+affix):
			pressedOnCharacter(player, 0)
		elif event.is_action_pressed("walk_left_"+affix):
			pressedOnCharacter(player, 1)
		elif event.is_action_pressed("walk_right_"+affix):
			pressedOnCharacter(player, 2)
		elif event.is_action_pressed("facebutton_north_"+affix):
			pressedOnCharacter(player, 4)
		elif event.is_action_pressed("facebutton_south_"+affix):
			pressedOnCharacter(player, 5)
		elif event.is_action_pressed("facebutton_west_"+affix):
			pressedOnCharacter(player, 6)
		elif event.is_action_pressed("facebutton_east_"+affix):
			pressedOnCharacter(player, 7)

func pressedOnCharacter(player, character):
	GameManager.npcDamageMultiplier[character] = GameManager.npcDamageMultiplier[character]/2
	setPlayerReady(player)

func setPlayerReady(player):
	waitingForPlayers.erase(player)
	waitingForPlayersVisuals[GameManager.playerColors[player]].visible = false
	if waitingForPlayers.size() <= 0:
		get_tree().change_scene_to_file("res://Battle Phase/BattleSceneNew.tscn")
