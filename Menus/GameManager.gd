extends Node

var players : Dictionary = {} # control affix for each player
var objectives : Dictionary = {} # NPC index assigned to each player
var playerColors : Dictionary = {} # color assigned to each player
var pointerPack = preload("res://Menus/Pointer.tscn")
var playerPack = preload("res://Playable Character/Player.tscn")
var npcHealth : Array[float] = []
var npcDamageMultiplier : Array[float] = [1,1,1,1,1,1,1,1]
var daySeconds = 1.5*60
var colorsName = ["Red","Blue","Green","Yellow","Pink","Purple","Orange","Aquamarine"]
var colors : Array[Color] = [Color.INDIAN_RED, Color.ROYAL_BLUE, Color.LAWN_GREEN, Color.YELLOW, Color.HOT_PINK, Color.REBECCA_PURPLE, Color.DARK_ORANGE, Color.AQUAMARINE]
var showingPanel = false
var winner = 0 # Index of the winner player
var maxHealth = 100

var NUMBER_OF_NPCS = 8

func asignNpcsToPlayers():
	# Set max value to all npcs
	var availableNpcs = []
	for i in range(NUMBER_OF_NPCS):
		npcHealth.append(maxHealth)
		availableNpcs.append(i)
	# asign a random npc to each player
	for key in players.keys():
		var npc = availableNpcs.pick_random()
		availableNpcs.erase(npc)
		objectives[key] = npc

# TODO: Fix broken sprites -> piano, apple maybe electricity
# TODO: Fix controls
# TODO: Add music and sound effects
# TODO: Add game options (volumes, controls)
# -------------------------
# TODO: Fix how the game looks on non 16:9 monitors
# TODO: Make sprites work correctly with YSort
# TODO: Add gameplay options (hidden characters, etc)
# TODO: Add random events (rain, )
# TODO: Add cheats (heal all, etc)
# TODO: Improve sprites
# TODO: Add shaders
