extends Control

@export var player : int
var pointerVelocity
var POINTER_SPEED = 450
var _playerControlsAffix : String

func init(i):
	player = i
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

func get_input():
	var input_dir = Input.get_vector("walk_left_"+_playerControlsAffix, "walk_right_"+_playerControlsAffix, "walk_up_"+_playerControlsAffix, "walk_down_"+_playerControlsAffix)
	pointerVelocity = input_dir * POINTER_SPEED

func _input(event):
	if event.is_action_pressed("interact_"+_playerControlsAffix):
		click()

func _physics_process(delta):
	get_input()
	movePointer(pointerVelocity * delta)

func movePointer(speed):
	position = position + speed
	lockPostitionInsideScreen()

func lockPostitionInsideScreen():
	position.x = max(position.x, 0)
	position.y = max(position.y, 0)
	
	position.x = min(position.x, get_viewport_rect().size.x-size.x)
	position.y = min(position.y, get_viewport_rect().size.y-size.y)

func click():
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = Vector2i(self.global_position)
	Input.parse_input_event(event)
	await get_tree().process_frame
	event.pressed = false
	Input.parse_input_event(event)
