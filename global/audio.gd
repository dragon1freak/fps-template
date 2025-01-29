extends Node

# Code adapted from KidsCanCode

var num_players := 18
var default_bus := "Master"
var default_volume := -6.0

var available = []  # The available players.
var queue = []  # The queue of sounds to play.


func _ready() -> void:
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)

		available.append(p)

		p.volume_db = default_volume
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = default_bus


func _on_stream_finished(stream) -> void:
	available.append(stream)


func play(sound, bus := default_bus, volume := default_volume) -> void:
	if sound is String:
		play_by_path(sound, bus, volume)
	elif sound is AudioStream:
		play_by_stream(sound, bus, volume)


func play_by_path(sound_path: String, bus : String, volume : float) -> void:
	var sounds = sound_path.split(",")
	var audio_stream = load("res://" + sounds[randi() % sounds.size()].strip_edges())
	queue.append({"stream": audio_stream, "bus": bus, "volume": volume})


func play_by_stream(audio_stream: AudioStream, bus : String, volume : float) -> void:
	queue.append({"stream": audio_stream, "bus": bus, "volume": volume})


func _process(_delta) -> void:
	if not queue.is_empty() and not available.is_empty():
		var next = queue.pop_front()
		var next_player = available.pop_front()
		if next.stream is String:
			next_player.stream = load(next.stream)
		elif next.stream is AudioStream:
			next_player.stream = next.stream
		
		if next_player.bus != next.bus and AudioServer.get_bus_index(next.bus) > 0:
			next_player.bus = next.bus
		next_player.volume_db = next.volume
		next_player.play()
		next_player.pitch_scale = randf_range(0.9, 1.1)
