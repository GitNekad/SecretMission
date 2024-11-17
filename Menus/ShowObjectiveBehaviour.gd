extends Node

@export var waitingForPlayersVisuals : Array[Control]
@export var correctPlayerSound : AudioStreamPlayer

var waitingForPlayers = []
var playerIsHoldingButton = [[false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false]]
var playerHoldingButtonTimer = [[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0]]

func _ready():
	MusicPlayer.playMenuMusic()
	var unusedColors = [0,1,2,3,4,5,6,7]
	for key in GameManager.playerColors:
		unusedColors.erase(GameManager.playerColors[key])
		waitingForPlayers.append(key)
	for color in unusedColors:
		waitingForPlayersVisuals[color].visible = false

func _input(event):
	for player in waitingForPlayers:
		var affix = GameManager.players[player]
		if event.is_action_pressed("walk_down_"+affix):
			playerIsHoldingButton[player][3] = true
			pressedOnCharacter(player, 3)
		elif event.is_action_pressed("walk_up_"+affix):
			playerIsHoldingButton[player][0] = true
			pressedOnCharacter(player, 0)
		elif event.is_action_pressed("walk_left_"+affix):
			playerIsHoldingButton[player][1] = true
			pressedOnCharacter(player, 1)
		elif event.is_action_pressed("walk_right_"+affix):
			playerIsHoldingButton[player][2] = true
			pressedOnCharacter(player, 2)
		elif event.is_action_pressed("facebutton_north_"+affix):
			playerIsHoldingButton[player][4] = true
			pressedOnCharacter(player, 4)
		elif event.is_action_pressed("facebutton_south_"+affix):
			playerIsHoldingButton[player][5] = true
			pressedOnCharacter(player, 5)
		elif event.is_action_pressed("facebutton_west_"+affix):
			playerIsHoldingButton[player][6] = true
			pressedOnCharacter(player, 6)
		elif event.is_action_pressed("facebutton_east_"+affix):
			playerIsHoldingButton[player][7] = true
			pressedOnCharacter(player, 7)
			
		elif event.is_action_released("walk_down_"+affix):
			playerIsHoldingButton[player][3] = false
			playerHoldingButtonTimer[player][3] = 0
		elif event.is_action_released("walk_up_"+affix):
			playerIsHoldingButton[player][0] = false
			playerHoldingButtonTimer[player][0] = 0
		elif event.is_action_released("walk_left_"+affix):
			playerIsHoldingButton[player][1] = false
			playerHoldingButtonTimer[player][1] = 0
		elif event.is_action_released("walk_right_"+affix):
			playerIsHoldingButton[player][2] = false
			playerHoldingButtonTimer[player][2] = 0
		elif event.is_action_released("facebutton_north_"+affix):
			playerIsHoldingButton[player][4] = false
			playerHoldingButtonTimer[player][4] = 0
		elif event.is_action_released("facebutton_south_"+affix):
			playerIsHoldingButton[player][5] = false
			playerHoldingButtonTimer[player][5] = 0
		elif event.is_action_released("facebutton_west_"+affix):
			playerIsHoldingButton[player][6] = false
			playerHoldingButtonTimer[player][6] = 0
		elif event.is_action_released("facebutton_east_"+affix):
			playerIsHoldingButton[player][7] = false
			playerHoldingButtonTimer[player][7] = 0

func _process(delta):
	for player in waitingForPlayers:
		for i in range(0,8):
			if playerIsHoldingButton[player][i]:
				var newTime = playerHoldingButtonTimer[player][i] + delta
				playerHoldingButtonTimer[player][i] = newTime
				if newTime > 3:
					setPlayerReady(player)

func pressedOnCharacter(player, character):
	if GameManager.objectives[player] == character:
		print("pressed on the objective") # TODO: play a sound
		correctPlayerSound.play()

func setPlayerReady(player):
	waitingForPlayers.erase(player)
	waitingForPlayersVisuals[GameManager.playerColors[player]].visible = false
	if waitingForPlayers.size() <= 0:
		get_tree().change_scene_to_file("res://Battle Phase/BattleSceneNew.tscn")
