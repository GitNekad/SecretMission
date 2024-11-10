extends Control

@export var playerHolders : Array[PlayerHolder]
@export var playButton : Button

var unselectedPlayersAffixes = ["P0","P1","P2","P3","P4","P5","P6","P7"]
var currentPlayer = 0

func _ready():
	setCurrentPlayerWaiting()

func _input(event):
	for affix in unselectedPlayersAffixes:
		if event.is_action_pressed("interact_"+affix):
			addNewPlayer(affix)

func addNewPlayer(affix):
	GameManager.players[currentPlayer] = affix
	unselectedPlayersAffixes.erase(affix)
	playerHolders[currentPlayer].readyForNewPlayer.visible = false
	playerHolders[currentPlayer].playerReady.visible = true
	var pointer = GameManager.pointerPack.instantiate()
	self.add_child(pointer)
	pointer.init(currentPlayer)
	currentPlayer += 1
	setCurrentPlayerWaiting()

func setCurrentPlayerWaiting():
	playButton.disabled = currentPlayer < 2
	playerHolders[currentPlayer].readyForNewPlayer.visible = true
	playerHolders[currentPlayer].playerReady.visible = false

func startGame():
	GameManager.asignNpcsToPlayers()
	get_tree().change_scene_to_file("res://Battle Phase/BattleSceneNew.tscn")
