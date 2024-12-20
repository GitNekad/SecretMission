extends Node2D
class_name NPCBehaviour

@export var navigationAgent : NavigationAgent2D
@export var pointsOfInterest : Array[Node2D]
@export var sprite : AnimatedSprite2D
@export var healthBar : ProgressBar
@export var sceneBehaviour : BattleSceneBehaviour
var moving : bool
var stun : bool = false
var characterLookingDirection : Vector2 = Vector2(0,1)
var currentPoi : POIBehaviour
var health : float = 100
var waitingTimer : SceneTreeTimer
var stunTimer : SceneTreeTimer
var index = 0

var CHARACTER_SPEED = 200
var PUSH_SPEED = 300
var MIN_WAIT_TIME = 10
var MAX_WAIT_TIME = 30
var MIN_STUN_TIME = 5
var MAX_STUN_TIME = 10

var READY = false
var exiled = false

func _ready():
	setNewTarget()
	navigationAgent.navigation_finished.connect(waitInPOIAndSetNewTarget)
	await get_tree().create_timer(0.5).timeout
	if exiled:
		exile()
		return
	mapReady()

func _physics_process(delta):
	if GameManager.showingPanel:
		return
	if !READY or stun:
		return
	if navigationAgent.is_target_reachable():
		if int(navigationAgent.distance_to_target()) > 4:
			var nextLocation = navigationAgent.get_next_path_position()
			var direction = global_position.direction_to(nextLocation).normalized()
			characterLookingDirection = direction * delta * CHARACTER_SPEED
			global_position += direction * delta * CHARACTER_SPEED
	animateSprite()

func setNewTarget():
	var oldPoi = currentPoi
	if oldPoi != null:
		oldPoi.available = true
	moving = true
	currentPoi = pointsOfInterest.pick_random()
	while !currentPoi.available or currentPoi == oldPoi:
		currentPoi = pointsOfInterest.pick_random()
	currentPoi.available = false
	var newPosition = currentPoi.global_position
	navigationAgent.set_target_position(newPosition)

func waitInPOIAndSetNewTarget():
	moving = false
	if currentPoi != null:
		characterLookingDirection = currentPoi.lookingPosition
	var waitTime = randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)
	waitingTimer = get_tree().create_timer(waitTime)
	await waitingTimer.timeout
	if stun:
		return
	if currentPoi != null:
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

func hurt(value):
	pushTo(self, 0)
	reduceHealth(value)

func pushTo(pushPosition : Node2D, damage):
	var stunTime = randf_range(MIN_STUN_TIME, MAX_STUN_TIME)
	stunTimer = get_tree().create_timer(stunTime)
	stun = true
	sprite.play("Stun")
	if waitingTimer != null:
		waitingTimer.time_left = 0
	currentPoi.available = true
	var initialPosition = global_position
	var finalPosition = pushPosition.global_position
	var lastDistance = global_position.distance_to(finalPosition) + 0.01
	while lastDistance > global_position.distance_to(finalPosition):
		lastDistance = global_position.distance_to(finalPosition)
		global_position = global_position + (finalPosition-global_position).normalized()*0.01*PUSH_SPEED
		await get_tree().create_timer(0.01).timeout
	
	global_position = finalPosition
	reduceHealth(damage)
	await stunTimer.timeout
	stun = false
	setNewTarget()

func mapReady():
	READY = true

func setHealth(value):
	health = value
	healthBar.value = health
	healthBar.max_value = GameManager.maxHealth
	if health <=0:
		exile()

func reduceHealth(damage):
	health -= damage*GameManager.npcDamageMultiplier[index]
	healthBar.value = health
	if health <=0:
		exile()
		sceneBehaviour.showIncapacitatedNPCPanel(index)

func exile():
	if currentPoi != null:
		currentPoi.available = true
		currentPoi = null
	READY = false
	exiled = true
	position = Vector2i(0,0)
	visible = false
