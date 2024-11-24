extends Control

@export var musicSlider : HSlider
@export var sfxSlider : HSlider
@export var fullscreenButton : CheckButton
@export var sampleSFXSound : AudioStreamPlayer
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

func _ready():
	MusicPlayer.playMenuMusic()
	musicSlider.grab_focus()
	musicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS_ID))
	sfxSlider.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS_ID))
	fullscreenButton.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func onMusicSliderChange(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value<0.04)
	
func onSFXSliderChange(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value<0.04)
	sampleSFXSound.play()

func onFullscreenToggled(value):
	var mode = DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)

func returnToMenu():
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
