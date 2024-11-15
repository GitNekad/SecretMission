extends Node2D
class_name BattleSceneBehaviour

@export var npcs : Array[NPCBehaviour]
@export var timer : TextureProgressBar
@export var playerHolder : Node2D
@export var playerSpawnPoints : Array[Node2D]

@export var npcIncapacitatedPanel : Node2D
@export var xWasIncapacitated : Label
@export var incapacitatedSprite : AnimatedSprite2D
@export var statusLabel : Label

@export var playerWonPanel : Node2D

var _remainingTime
var _players : Array[PlayerBehaviour] = []

func _ready():
	if GameManager.npcHealth.size()>0:
		setNpcsHealth()
	setTimer()
	instantiatePlayers()

func _process(delta):
	if GameManager.showingPanel:
		return
	updateTimer(delta)

func setNpcsHealth():
	for i in range(npcs.size()):
		npcs[i].setHealth(GameManager.npcHealth[i])
		npcs[i].index = i

func setTimer():
	_remainingTime = GameManager.daySeconds
	timer.max_value = _remainingTime
	timer.value = _remainingTime

func updateTimer(delta):
	_remainingTime = _remainingTime-delta
	timer.value = _remainingTime
	if _remainingTime < 0:
		timeOver()

func timeOver():
	for i in range(npcs.size()):
		GameManager.npcHealth[i] = npcs[i].health
	get_tree().change_scene_to_file("res://Menus/BetweenDays.tscn")

func instantiatePlayers():
	playerSpawnPoints.shuffle()
	var playersToSpawn = GameManager.players.keys() if GameManager.players.size() > 0 else [0,1]
	for player in playersToSpawn:
		var playerObj = GameManager.playerPack.instantiate()
		playerHolder.add_child(playerObj)
		playerObj.instantiateCharacter(playerSpawnPoints[player].global_position, player)
		_players.append(playerObj)

func showIncapacitatedNPCPanel(npcIndex : int):
	GameManager.showingPanel = true
	npcIncapacitatedPanel.visible = true
	match npcIndex:
		0: # Axolotl
			xWasIncapacitated.text = "Axl was incapacitated"
			incapacitatedSprite.play("Axolotl")
		1: # Cat
			xWasIncapacitated.text = "Kat was incapacitated"
			incapacitatedSprite.play("Cat")
		2: # Hare
			xWasIncapacitated.text = "Hare was incapacitated"
			incapacitatedSprite.play("Hare")
		3: # Monki
			xWasIncapacitated.text = "Monki was incapacitated"
			incapacitatedSprite.play("Monki")
		4: # Owl
			xWasIncapacitated.text = "Owl was incapacitated"
			incapacitatedSprite.play("Owl")
		5: # Penwin
			xWasIncapacitated.text = "Penwin was incapacitated"
			incapacitatedSprite.play("Penwin")
		6: # Ram
			xWasIncapacitated.text = "Ram was incapacitated"
			incapacitatedSprite.play("Ram")
		7: # Rat
			xWasIncapacitated.text = "Rat was incapacitated"
			incapacitatedSprite.play("Rat")
	for key in GameManager.objectives:
		if GameManager.objectives[key] == npcIndex:
			var color = GameManager.playerColors[key]
			statusLabel.modulate = GameManager.colors[color]
			statusLabel.text = GameManager.colorsName[color] + "´s objective"
			await get_tree().create_timer(3).timeout
			playerWon(key)
			return
	statusLabel.modulate = Color.WHITE
	statusLabel.text = "No one's objective"
	await get_tree().create_timer(3).timeout
	hideIncapacitatedNPCPanel()

func hideIncapacitatedNPCPanel():
	npcIncapacitatedPanel.visible = false
	GameManager.showingPanel = false

func playerWon(player : int):
	GameManager.winner = player
	get_tree().change_scene_to_file("res://Menus/PlayerWonScene.tscn")
	GameManager.showingPanel = false
