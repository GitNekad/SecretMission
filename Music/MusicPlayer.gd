extends AudioStreamPlayer

const battleMusic = preload("res://Music/761764__universfield__halloween-mischief-playful-music-for-halloween-festivities.mp3")
const menuMusic = preload("res://Music/167419__kasa90__chiptune-loop.ogg")
const victoryMusic = preload("res://Music/704530__universfield__path-to-victory.mp3")

func playBattleMusic():
	_play_music(battleMusic)
	
func playMenuMusic():
	_play_music(menuMusic)
	
func playVictoryMusic():
	_play_music(victoryMusic)

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	bus = "Music"
	stream = music
	volume_db = volume_db
	play()
