extends Control
class_name PlayerHolder

@export var readyForNewPlayer : Control
@export var waitingForPlayerSetup : Control
@export var playerReady : Control

@export var playerColorShow : AnimatedSprite2D
@export var playerReadyColorShow : AnimatedSprite2D
@export var playerReadyText : Label

var _waitingForInput = false
var playerAffix = ""
var _playerColor = 0
var _selectPlayersBehaviour
var _playerIndex


func _input(event):
	if !_waitingForInput:
		return
	if event.is_action_pressed("interact_"+playerAffix):
		setPlayerReadyToPlay()
	elif event.is_action_pressed("walk_left_"+playerAffix):
		setColor(_playerColor-1)
	elif event.is_action_pressed("walk_right_"+playerAffix):
		setColor(_playerColor+1)

func initialize(playerIndex, newAffix, selectPlayersBehaviour):
	_playerIndex = playerIndex
	_selectPlayersBehaviour = selectPlayersBehaviour
	playerAffix = newAffix
	_waitingForInput = true
	setColor(playerIndex)
	playerColorShow.play("F-Walk")
	playerReadyColorShow.play("F-Idle")

func setColor(value):
	_waitingForInput = true
	if _selectPlayersBehaviour.unselectedColors.has(value):
		_playerColor = value
		playerColorShow.modulate = GameManager.colors[value]
		playerReadyColorShow.modulate = GameManager.colors[value]
		playerReadyText.modulate = GameManager.colors[value]
		playerReadyText.text = GameManager.colorsName[value] + " ready"
		return
	if value >= 7:
		setColor(0)
	elif value <= -1:
		setColor(7)
	else:
		setColor(value+1)

func setPlayerReadyToPlay():
	_waitingForInput = false
	_selectPlayersBehaviour.setPlayerReady(_playerColor, _playerIndex)
