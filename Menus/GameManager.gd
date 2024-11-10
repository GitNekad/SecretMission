extends Node

var players : Dictionary = {} # control affix for each player
var objectives : Dictionary = {} # NPC index assigned to each player
var pointerPack = preload("res://Menus/Pointer.tscn")
var playerPack = preload("res://Playable Character/Player.tscn")
var npcHealth : Array[int] = []
var daySeconds = 3*60

var NUMBER_OF_NPCS = 8

func asignNpcsToPlayers():
	# Set max value to all npcs
	var availableNpcs = []
	for i in range(NUMBER_OF_NPCS):
		npcHealth.append(100)
		availableNpcs.append(i)
	# asign a random npc to each player
	for key in players.keys():
		var npc = availableNpcs.pick_random()
		availableNpcs.erase(npc)
		objectives[key] = npc

# TODO: Show panel when NPC dies
# TODO: Do between days behaviour
