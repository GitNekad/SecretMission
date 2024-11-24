extends Node

@export var introductionPanel : Control
@export var controlsPanel : Control
@export var playerSelectionPanel : Control
@export var startOfTheGamePanel : Control
@export var actionPhasePanel : Control
@export var charactersProtectionPanel : Control
@export var creditsPanel : Control
@export var firstButton : Button

func _ready():
	MusicPlayer.playMenuMusic()
	firstButton.grab_focus()

func openIntroductionPanel():
	introductionPanel.visible = true
	controlsPanel.visible = false
	playerSelectionPanel.visible = false
	startOfTheGamePanel.visible = false
	actionPhasePanel.visible = false
	charactersProtectionPanel.visible = false
	creditsPanel.visible = false

func openControlsPanel():
	introductionPanel.visible = false
	controlsPanel.visible = true
	playerSelectionPanel.visible = false
	startOfTheGamePanel.visible = false
	actionPhasePanel.visible = false
	charactersProtectionPanel.visible = false
	creditsPanel.visible = false

func openPlayerSelectionPanel():
	introductionPanel.visible = false
	controlsPanel.visible = false
	playerSelectionPanel.visible = true
	startOfTheGamePanel.visible = false
	actionPhasePanel.visible = false
	charactersProtectionPanel.visible = false
	creditsPanel.visible = false

func openStartOfTheGamePanel():
	introductionPanel.visible = false
	controlsPanel.visible = false
	playerSelectionPanel.visible = false
	startOfTheGamePanel.visible = true
	actionPhasePanel.visible = false
	charactersProtectionPanel.visible = false
	creditsPanel.visible = false

func openActionPhasePanel():
	introductionPanel.visible = false
	controlsPanel.visible = false
	playerSelectionPanel.visible = false
	startOfTheGamePanel.visible = false
	actionPhasePanel.visible = true
	charactersProtectionPanel.visible = false
	creditsPanel.visible = false

func openCharactersProtectionPanel():
	introductionPanel.visible = false
	controlsPanel.visible = false
	playerSelectionPanel.visible = false
	startOfTheGamePanel.visible = false
	actionPhasePanel.visible = false
	charactersProtectionPanel.visible = true
	creditsPanel.visible = false

func openCreditsPanel():
	introductionPanel.visible = false
	controlsPanel.visible = false
	playerSelectionPanel.visible = false
	startOfTheGamePanel.visible = false
	actionPhasePanel.visible = false
	charactersProtectionPanel.visible = false
	creditsPanel.visible = true

func mainMenu():
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
