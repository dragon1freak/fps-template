extends Node
## Global audio node to simplify playing non-directional sounds on demand.
## Creates a number of players with a specified bus and volume to play AudioStreams
## both directly and through a path string.
##
## Code adapted from KidsCanCode

## Number of AudioStreamPlayer nodes to create.  Set higher if a lot of sounds are being played and old sounds are getting cut
var num_players := 18
## Default bus for the players
var default_bus := "Master"
## Default volume_db for the players
var default_volume := -6.0

## Array of available players
var available : Array[AudioStreamPlayer] = []
## Array of sound objects queued to play
var queue : Array[Dictionary] = []


func _ready() -> void:
	_create_players()


func _process(_delta) -> void:
	_check_queue()


## Creates an amount of AudioStreamPlayer nodes equal to num_players and adds them to the scene.
## The default bus and volume are set and the player is added to the array of available players.
func _create_players() -> void:
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
	
		available.append(p)
	
		p.volume_db = default_volume
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = default_bus


## Simplified play function, can be given either an AudioStream or a path string as the sound.
## The bus is the target Audio Bus and the volume is the target player volume_db
func play(sound, bus := default_bus, volume := default_volume) -> void:
	if sound is String:
		play_by_path(sound, bus, volume)
	elif sound is AudioStream:
		play_by_stream(sound, bus, volume)


## Play function that only takes string paths as a sound.
## The bus is the target Audio Bus and the volume is the target player volume_db
func play_by_path(sound_path: String, bus : String, volume : float) -> void:
	var sounds = sound_path.split(",")
	var audio_stream = load("res://" + sounds[randi() % sounds.size()].strip_edges())
	queue.append({"stream": audio_stream, "bus": bus, "volume": volume})


## Play function that only accepts an AudioStream as the sound
## The bus is the target Audio Bus and the volume is the target player volume_db
func play_by_stream(audio_stream: AudioStream, bus : String, volume : float) -> void:
	queue.append({"stream": audio_stream, "bus": bus, "volume": volume})


## Checks if the queue has a sound to play and if there are available AudioStreamPlayers
## and plays them.  The available AudioStreamPlayer's bus and volume_db are set to the values
## held in the sound object.  The pitch is slightly varried so repetetive sounds have variation
func _check_queue() -> void:
	if not queue.is_empty() and not available.is_empty():
		var next = queue.pop_front()
		var next_player = available.pop_front()
		next_player.stream = next.stream
		
		if next_player.bus != next.bus and AudioServer.get_bus_index(next.bus) > 0:
			next_player.bus = next.bus
		next_player.volume_db = next.volume
		next_player.pitch_scale = randf_range(0.9, 1.1)
		
		next_player.play()


func _on_stream_finished(stream) -> void:
	available.append(stream)
