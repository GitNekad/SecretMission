extends Node

var character : PlayableCharacterBehaviour
var characterVelocity : Vector2
var characterLookingDirection : Vector2 = Vector2(0,1)
var _characterPack = preload("res://Playable Character/PlayableCharacter.tscn")

var CHARACTER_SPEED = 300

func _ready():
	instantiateCharacter(Vector2i(-263,152))

func _input(event):
	if event.is_action_pressed("ui_accept"):
		interact()

func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	characterVelocity = input_dir * CHARACTER_SPEED
	animateSprite()

func _physics_process(delta):
	get_input()
	character.move_and_collide(characterVelocity * delta)

func instantiateCharacter(position: Vector2i):
	character = _characterPack.instantiate() 
	self.add_child(character)
	character.position = position

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
