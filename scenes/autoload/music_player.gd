extends AudioStreamPlayer

var music_tracks = {
	"main_menu": preload("res://assets/audio/music/Chiptune Vol2 Work Work Work Main.wav"),
	"haunted_temple": preload("res://assets/audio/music/Chiptune Action Suspense main.wav"),
	"frozen_labyrinth": preload("res://assets/audio/music/Chiptune Action Mysterious main.wav")
}

var current_track: String = ""
var is_fading: bool = false


func _ready() -> void:
	current_track = "main_menu"
	finished.connect(on_finished)
	$Timer.timeout.connect(on_timer_timeout)


func play_music(track_name: String, fade_in: bool = false, fade_duration: float = 1.0):
	if track_name == current_track and playing:
		return # Already playing this track
	
	if not music_tracks.has(track_name):
		print("Warning: Music track '%s' not found!" % track_name)
		return
	
	if fade_in and playing:
		fade_to_track(track_name, fade_duration)
	else:
		play_track_immediately(track_name)


func fade_to_track(track_name: String, duration: float = 1.0):
	if is_fading:
		return
	
	is_fading = true
	var original_volume = volume_db
	
	# Fade out current track
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80.0, duration / 2)
	await tween.finished
	
	# Switch to new track
	play_track_immediately(track_name)
	
	# Fade in new track
	volume_db = -80.0
	tween = create_tween()
	tween.tween_property(self, "volume_db", original_volume, duration / 2)
	await tween.finished
	
	is_fading = false


func play_track_immediately(track_name: String):
	current_track = track_name
	stream = music_tracks[track_name]
	play()

# Stop music with optional fade out
func stop_music(fade_out: bool = false, fade_duration: float = 1.0):
	if fade_out and playing:
		var tween = create_tween()
		tween.tween_property(self, "volume_db", -80.0, fade_duration)
		await tween.finished
	
	stop()
	current_track = ""

# Pause/resume functions
func pause_music():
	stream_paused = true

func resume_music():
	stream_paused = false

# Volume control
func set_volume(_volume_db: float):
	volume_db = _volume_db

func get_current_track() -> String:
	return current_track

func on_finished() -> void:
	$Timer.start()

func on_timer_timeout() -> void:
	play()
