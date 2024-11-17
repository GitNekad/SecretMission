extends Control

@export var playerHolders : Array[PlayerHolder]
@export var playButton : Button

var unselectedPlayersAffixes = ["P0","P1","P2","P3","P4","P5","P6","P7"]
var unselectedColors = [0,1,2,3,4,5,6,7]
var currentPlayer = 0
var readyPlayers = 0

func _ready():
	MusicPlayer.playMenuMusic()
	setCurrentPlayerWaiting()

func _input(event):
	for affix in unselectedPlayersAffixes:
		if event.is_action_pressed("interact_"+affix):
			addNewPlayer(affix)
		elif event.is_action_pressed("walk_down_"+affix):
			addNewPlayer(affix)
		elif event.is_action_pressed("walk_up_"+affix):
			addNewPlayer(affix)
		elif event.is_action_pressed("walk_left_"+affix):
			addNewPlayer(affix)
		elif event.is_action_pressed("walk_right_"+affix):
			addNewPlayer(affix)

func addNewPlayer(affix):
	GameManager.players[currentPlayer] = affix
	unselectedPlayersAffixes.erase(affix)
	playerHolders[currentPlayer].initialize(currentPlayer, affix, self)
	playerHolders[currentPlayer].readyForNewPlayer.visible = false
	playerHolders[currentPlayer].waitingForPlayerSetup.visible = true
	playerHolders[currentPlayer].playerReady.visible = false
	currentPlayer += 1
	setCurrentPlayerWaiting()

func setCurrentPlayerWaiting():
	playButton.disabled = true
	playerHolders[currentPlayer].readyForNewPlayer.visible = true
	playerHolders[currentPlayer].waitingForPlayerSetup.visible = false
	playerHolders[currentPlayer].playerReady.visible = false

func setPlayerReady(colorIndex, playerIndex):
	if !unselectedColors.has(colorIndex):
		playerHolders[playerIndex].setColor(colorIndex+1)
		return
	unselectedColors.erase(colorIndex)
	GameManager.playerColors[playerIndex] = colorIndex
	playerHolders[playerIndex].readyForNewPlayer.visible = false
	playerHolders[playerIndex].waitingForPlayerSetup.visible = false
	playerHolders[playerIndex].playerReady.visible = true
	var pointer = GameManager.pointerPack.instantiate()
	self.add_child(pointer)
	pointer.init(playerIndex)
	
	readyPlayers += 1
	playButton.disabled = currentPlayer < 1 or !readyPlayers == currentPlayer

func startGame():
	GameManager.asignNpcsToPlayers()
	get_tree().change_scene_to_file("res://Menus/ShowObjective.tscn")
