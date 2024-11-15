extends AnimatedSprite2D

@export var beginningPosition : Node2D
@export var endPosition : Node2D
@export var hitArea : Area2D
@export var pushToPosition : Node2D

var MIN_WAITING_TIME = 0
var MAX_WAITING_TIME = 20
var MIN_SPEED = 200
var MAX_SPEED = 400

var waitingTime
var currentSpeed
var isMoving = false

func _ready():
	hitArea.body_entered.connect(hitEntered)
	play("default")
	startMovingAfterTime()

func _process(delta):
	if GameManager.showingPanel:
		return
	if isMoving:
		position.x = position.x - delta * currentSpeed
		if position.x < endPosition.position.x:
			startMovingAfterTime()

func startMovingAfterTime():
	isMoving = false
	waitingTime = randf_range(MIN_WAITING_TIME, MAX_WAITING_TIME)
	currentSpeed = randf_range(MIN_SPEED, MAX_SPEED)
	await get_tree().create_timer(waitingTime).timeout
	position = beginningPosition.position
	isMoving = true

func hitEntered(body):
	if body is NPCBehaviour:
		body.pushTo(pushToPosition, 30)
