extends Node2D

@export var navigationAgent : NavigationAgent2D
@export var pointsOfInterest : Array[Node2D]
@export var sprite : AnimatedSprite2D
var moving : bool
var characterLookingDirection : Vector2 = Vector2(0,1)
var currentPoi : POIBehaviour

var CHARACTER_SPEED = 75
var MIN_WAIT_TIME = 10
var MAX_WAIT_TIME = 30

func _ready():
	setNewTarget()
	navigationAgent.navigation_finished.connect(waitInPOIAndSetNewTarget)

func _physics_process(delta):
	if navigationAgent.is_target_reachable():
		if int(navigationAgent.distance_to_target()) > 4:
			var nextLocation = navigationAgent.get_next_path_position()
			var direction = global_position.direction_to(nextLocation).normalized()
			characterLookingDirection = direction * delta * CHARACTER_SPEED
			global_position += direction * delta * CHARACTER_SPEED
	animateSprite()

func setNewTarget():
	moving = true
	currentPoi = pointsOfInterest.pick_random()
	while !currentPoi.available:
		currentPoi = pointsOfInterest.pick_random()
	currentPoi.available = false
	var newPosition = currentPoi.global_position
	navigationAgent.set_target_position(newPosition)

func waitInPOIAndSetNewTarget():
	moving = false
	characterLookingDirection = currentPoi.lookingPosition
	var waitTime = randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)
	await get_tree().create_timer(waitTime).timeout
	currentPoi.available = true
	setNewTarget()

func animateSprite():
	var lookingAt : String
	var movement : String
	if !moving:
		movement = "Idle"
	else:
		movement = "Walk"
	sprite.flip_h = !characterLookingDirection.x > 0
	if absf(characterLookingDirection.x) > absf(characterLookingDirection.y):
		lookingAt = "S-"
	elif characterLookingDirection.y > 0:
		lookingAt = "F-"
	else:
		lookingAt = "B-"
	if sprite.animation != lookingAt+movement:
		sprite.play(lookingAt+movement)
