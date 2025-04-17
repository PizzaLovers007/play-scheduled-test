extends AudioStreamPlayer

@export var bpm: float = 130

var _running: bool = false
var _start_absolute_time: float = 0
var _scheduled_time: float = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _running:
		return
	#var curr_time = AudioServer.get_absolute_time()
	var curr_time = Time.get_ticks_usec() / 1000000.0
	if curr_time > _scheduled_time+0.05:
		var beat_time = 60 / bpm
		var next_tick = ceil((curr_time - _start_absolute_time) / beat_time)
		_scheduled_time = _start_absolute_time + next_tick * beat_time
		#play_scheduled(_scheduled_time)
		play()
		print("scheduling: ", _scheduled_time, " ", next_tick)


func start(start_absolute_time: float) -> void:
	_running = true
	_start_absolute_time = start_absolute_time
	_scheduled_time = start_absolute_time
	#play_scheduled(_scheduled_time)
	play()
	print("scheduling: ", _scheduled_time, " ", 0)
