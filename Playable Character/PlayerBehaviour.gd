extends Node
class_name PlayerBehaviour

@export var player : int

var character : PlayableCharacterBehaviour
var characterVelocity : Vector2
var characterLookingDirection : Vector2 = Vector2(0,1)
var _characterPack = preload("res://Playable Character/PlayableCharacter.tscn")

var CHARACTER_SPEED = 300
var _playerControlsAffix : String
var _readyToReadInputs = false

func setControlAffix():
	if GameManager.players.has(player):
		_playerControlsAffix = GameManager.players[player]
		return
	match player:
		0:
			_playerControlsAffix = "P0"
		1:
			_playerControlsAffix = "P1"
		2:
			_playerControlsAffix = "P2"
		3:
			_playerControlsAffix = "P3"
		4:
			_playerControlsAffix = "P4"
		5:
			_playerControlsAffix = "P5"
		6:
			_playerControlsAffix = "P6"
		7:
			_playerControlsAffix = "P7"

func _input(event):
	if !_readyToReadInputs:
		return
	if GameManager.showingPanel:
		return
	if event.is_action_pressed("interact_"+_playerControlsAffix):
		interact()

func get_input():
	var input_dir = Input.get_vector("walk_left_"+_playerControlsAffix, "walk_right_"+_playerControlsAffix, "walk_up_"+_playerControlsAffix, "walk_down_"+_playerControlsAffix)
	characterVelocity = input_dir * CHARACTER_SPEED
	animateSprite()

func _physics_process(delta):
	if !_readyToReadInputs:
		return
	if GameManager.showingPanel:
		return
	get_input()
	character.move_and_collide(characterVelocity * delta, false, 0.7, false)

func instantiateCharacter(position: Vector2i, playerIndex, hiddenColor = false):
	player = playerIndex
	character = _characterPack.instantiate() 
	self.add_child(character)
	character.position = position
	setControlAffix()
	if GameManager.playerColors.has(playerIndex) and !hiddenColor:
		character.modulate = GameManager.colors[GameManager.playerColors[playerIndex]]
	await get_tree().create_timer(0.75).timeout
	_readyToReadInputs = true

func animateSprite():
	var lookingAt : String
	var movement : String
	if characterVelocity.length() < 0.001:
		movement = "Idle"
	else:
		movement = "Walk"
		characterLookingDirection = characterVelocity
	character.sprite.flip_h = !characterLookingDirection.x > 0
	if absf(characterLookingDirection.x) > absf(characterLookingDirection.y):
		lookingAt = "S-"
	elif characterLookingDirection.y > 0:
		lookingAt = "F-"
	else:
		lookingAt = "B-"
	if character.sprite.animation != lookingAt+movement:
		character.sprite.play(lookingAt+movement)

func interact():
	if character == null or character.currentInteractable == null:
		return
	character.currentInteractable.activate()
