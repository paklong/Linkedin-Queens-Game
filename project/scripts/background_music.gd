extends Control

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var music_image: Sprite2D = %MusicImage
@onready var music_button: Button = %MusicButton


const LUDUM_DARE_30___06 = preload("res://assets/musics/Ludum Dare 30 - 06.ogg")
const STREAM_LOOPS_2024_01_24_02 = preload("res://assets/musics/Stream Loops 2024-01-24_02.ogg")
const STREAM_LOOPS_2024_02_28_02 = preload("res://assets/musics/Stream Loops 2024-02-28_02.ogg")
const STREAM_LOOPS_2024_04_24_02 = preload("res://assets/musics/Stream Loops 2024-04-24_02.ogg")
const STREAM_LOOPS_2024_04_24_03 = preload("res://assets/musics/Stream Loops 2024-04-24_03.ogg")
const THE_VERDANT_GROVE = preload("res://assets/musics/The Verdant Grove.ogg")


var current_music_index : int

var musics : Array[Resource] = [
	LUDUM_DARE_30___06,
	STREAM_LOOPS_2024_01_24_02,
	STREAM_LOOPS_2024_02_28_02,
	STREAM_LOOPS_2024_04_24_02,
	STREAM_LOOPS_2024_04_24_03,
	THE_VERDANT_GROVE,
]

var tween : Tween

func _ready() -> void:
	audio_stream_player.finished.connect(play_next_music)
	music_button.pressed.connect(toggle_music)
	current_music_index = randi_range(0, musics.size())  % musics.size()
	audio_stream_player.volume_db = -20
	play_music()
	
func play_next_music():
	current_music_index += 1
	current_music_index %= musics.size()
	play_music()
	
func play_music():
	audio_stream_player.stream = musics[current_music_index]
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(audio_stream_player, 'volume_db', 0, 5)
	
	audio_stream_player.play()
	
	var ease_out_duration := 10
	var wait_for := audio_stream_player.stream.get_length() - ease_out_duration
	
	await get_tree().create_timer(wait_for).timeout
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(audio_stream_player, 'volume_db', -40, ease_out_duration)
	

func toggle_music():
	audio_stream_player.stream_paused = !audio_stream_player.stream_paused
	if audio_stream_player.playing:
		music_image.frame = 11
	else:
		music_image.frame = 12





