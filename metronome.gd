extends AudioStreamPlayer

@export var bpm: float = 130

var _running: bool = false
var _start_absolute_time: float = 0
var _next_tick_time: float = -1


func _process(_delta: float) -> void:
	if not _running:
		return
	
	var curr_time = Time.get_ticks_usec() / 1000000.0
	if curr_time >= _next_tick_time:
		var beat_time = 60 / bpm
		var next_tick = ceil((curr_time + 0.001 - _start_absolute_time) / beat_time)
		_next_tick_time = _start_absolute_time + next_tick * beat_time
		play()
		print("playing: ", _next_tick_time, " ", next_tick)


func start(start_absolute_time: float) -> void:
	_running = true
	_start_absolute_time = start_absolute_time
	_next_tick_time = start_absolute_time
