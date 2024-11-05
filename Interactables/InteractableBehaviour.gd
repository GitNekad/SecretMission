extends AnimatedSprite2D
class_name InteractableBehaviour

@export var activationArea : Area2D
@export var hurtArea : Area2D
@export var damage : int
@export var unavailableIfAlone : bool = false
@export var pushPosition : Node2D 
var available = true

var victims : Array[NPCBehaviour]

func _ready():
	activationArea.body_entered.connect(activationEntered)
	activationArea.body_exited.connect(activationExited)
	hurtArea.body_entered.connect(hurtEntered)
	hurtArea.body_exited.connect(hurtExited)
	if unavailableIfAlone:
		play("Unavailable")
		available = false

func activate():
	if !available:
		return
	available = false
	if pushPosition != null:
		pushAllVictims()
		return
	play("Active")
	await animation_finished
	hurtAllVictims()

func activationEntered(body):
	if body is PlayableCharacterBehaviour:
		body.currentInteractable = self

func activationExited(body):
	if body is PlayableCharacterBehaviour:
		if body.currentInteractable == self:
			body.currentInteractable = null

func hurtEntered(body):
	if body is NPCBehaviour:
		victims.append(body)
		if animation == "Unavailable":
			play("Idle")
			available = true

func hurtExited(body):
	if body is NPCBehaviour:
		victims.erase(body)
		if unavailableIfAlone and victims.size() == 0:
			play("Unavailable")
			available = false

func hurtAllVictims():
	for victim in victims:
		victim.hurt(damage)

func pushAllVictims():
	for victim in victims:
		victim.pushTo(pushPosition, damage)
