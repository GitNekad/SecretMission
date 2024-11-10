extends Node2D

@export var npcs : Array[NPCBehaviour]
@export var timer : TextureProgressBar

var _remainingTime

func _ready():
	if GameManager.npcHealth.size()>0:
		setNpcsHealth()
	setTimer()

func _process(delta):
	updateTimer(delta)

func setNpcsHealth():
	for i in range(npcs.size()):
		npcs[i].setHealth(GameManager.npcHealth[i])

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
