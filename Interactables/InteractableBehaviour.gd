extends AnimatedSprite2D
class_name InteractableBehaviour

@export var activationArea : Area2D
@export var hurtArea : Area2D
@export var damage : int
@export var unavailableIfAlone : bool = false
@export var pushPosition : Node2D 
@export var interactionMarker : AnimatedSprite2D
@export var animationSound : AudioStreamPlayer
@export var animationSoundDelay : float
var available = true

var victims : Array[NPCBehaviour]

func _ready():
	activationArea.body_entered.connect(activationEntered)
	activationArea.body_exited.connect(activationExited)
	hurtArea.body_entered.connect(hurtEntered)
	hurtArea.body_exited.connect(hurtExited)
	if unavailableIfAlone:
		play("Unavailable")
		interactionMarker.play("Disable")
		available = false
	else:
		interactionMarker.play("Enable")

func activate():
	if !available:
		return
	available = false
	playSound()
	if pushPosition != null:
		pushAllVictims()
		return
	play("Active")
	interactionMarker.play("Disable")
	await animation_finished
	hurtAllVictims()

func playSound():
	if animationSound == null:
		return
	await get_tree().create_timer(animationSoundDelay).timeout
	animationSound.play()

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
			interactionMarker.play("Enable")
			available = true

func hurtExited(body):
	if body is NPCBehaviour:
		victims.erase(body)
		if unavailableIfAlone and victims.size() == 0:
			play("Unavailable")
			interactionMarker.play("Disable")
			available = false

func hurtAllVictims():
	for victim in victims:
		victim.hurt(damage)

func pushAllVictims():
	for victim in victims:
		victim.pushTo(pushPosition, damage)
